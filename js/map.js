var map = L.map('map').setView([27.8333, -81.7170], 6);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets-basic',
    accessToken: 'pk.eyJ1IjoiZGVsdGFzcGFyayIsImEiOiJjaWl1ejBmMDEwMDJldXNsejBjeHhhanBjIn0.kvUH_d89tMUM9TDoeA5G5w'
}).addTo(map);

for (var i = 0; i < fences.length; i++) {
    var circle = new L.circle([fences[i][0],fences[i][1]], fences[i][2],{
        weight: 0,
        fillColor: '#f03',
        fillOpacity: 0.2
    }).addTo(map);
}