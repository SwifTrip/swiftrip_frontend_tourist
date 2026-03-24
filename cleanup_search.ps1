$c = Get-Content 'lib/screens/searchTour.dart'
$new = $c[0..840] + $c[1013..($c.Count-1)]
$new | Out-File -FilePath 'lib/screens/searchTour.dart' -Encoding utf8
