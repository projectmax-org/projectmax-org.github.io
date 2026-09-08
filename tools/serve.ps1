<#
.SYNOPSIS
    Serves this folder on http://localhost:8080 for local preview. No dependencies beyond PowerShell.
    Root-relative links (/assets/...) need a real server; opening the files directly does not resolve them.
#>
param([int]$Port = 8080)
$root = (Resolve-Path "$PSScriptRoot\..").Path
$types = @{ '.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'; '.js'='text/javascript'; '.png'='image/png'; '.svg'='image/svg+xml'; '.ico'='image/x-icon'; '.txt'='text/plain'; '.md'='text/plain' }
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root on http://localhost:$Port/  (Ctrl+C to stop)"
try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        try {
            $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
            if ($path.EndsWith('/')) { $path += 'index.html' }
            $file = Join-Path $root ($path.TrimStart('/') -replace '/', '\')
            if ((Test-Path $file -PathType Container)) { $file = Join-Path $file 'index.html' }
            if (-not (Test-Path $file -PathType Leaf)) { $file = Join-Path $root '404.html'; $ctx.Response.StatusCode = 404 }
            $ext = [IO.Path]::GetExtension($file).ToLowerInvariant()
            $ctx.Response.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
            $bytes = [IO.File]::ReadAllBytes($file)
            $ctx.Response.ContentLength64 = $bytes.Length
            # A HEAD request gets the headers only; writing a body would violate the protocol.
            if ($ctx.Request.HttpMethod -ne 'HEAD') { $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length) }
        } catch {
            Write-Host "error serving $($ctx.Request.Url.AbsolutePath): $($_.Exception.Message)"
        } finally {
            try { $ctx.Response.Close() } catch { }
        }
    }
} finally { $listener.Stop() }
