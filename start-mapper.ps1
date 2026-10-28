# Serves slot-mapper.html at http://localhost:8321 so the browser is allowed to talk to WLED.
# Run:  powershell -ExecutionPolicy Bypass -File .\start-mapper.ps1
# Close this window to stop.

$root = [IO.Path]::GetFullPath((Split-Path -Parent $MyInvocation.MyCommand.Path))
$port = 8321
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Filament Rack Mapper running at http://localhost:$port/  (close this window to stop)"
Start-Process "http://localhost:$port/slot-mapper.html"

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $name = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
  if (-not $name) { $name = 'slot-mapper.html' }
  $file = [IO.Path]::GetFullPath((Join-Path $root $name))
  if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ctx.Response.ContentType = 'text/html; charset=utf-8'
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
  }
  $ctx.Response.Close()
}
