/*var fenceLayer = new L.LayerGroup();

for (var i = 0; i < fences.length; i++) {
    L.circle([fences[i][0],fences[i][1]], fences[i][2],{
        weight: 0,
        fillColor: '#f03',
        fillOpacity: 0.2
    }).addTo(fenceLayer);
}

var impressionLayer = new L.LayerGroup();

for (var j = 0; j < impressions.length; j++) {
    L.marker([impressions[j][0],impressions[j][1]]).addTo(impressionLayer);
}*/


var mbAttr = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    mbUrl = 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGVsdGFzcGFyayIsImEiOiJjaWl1ejBmMDEwMDJldXNsejBjeHhhanBjIn0.kvUH_d89tMUM9TDoeA5G5w';

/*var streets = L.tileLayer(mbUrl, {id: 'mapbox.streets-basic', attribution: mbAttr}),
    grayscale = L.tileLayer(mbUrl, {id: 'mapbox.light', attribution: mbAttr});

var map = L.map('map', {
    center: [27.8333, -81.7170],
    zoom: 6,
    layers: [streets, fenceLayer, impressionLayer]
});

var baseLayers = {
    "Streets": streets,
    "Grayscale": grayscale
};

var overlays = {
    "Fences": fenceLayer,
    "Impressions": impressionLayer
};

L.control.layers(baseLayers, overlays).addTo(map);*/

var streets = L.tileLayer(mbUrl, {id: 'mapbox.streets-basic', attribution: mbAttr});

var map = L.map('map', {
    center: [27.8333, -81.7170],
    zoom: 6,
    layers: [streets]
});

var progress = document.getElementById('progress');
var progressBar = document.getElementById('progress-bar');

function updateProgressBar(processed, total, elapsed, layersArray) {
    progress.style.display = 'block';
    progressBar.style.width = Math.round(processed/total*100) + '%';

    if (processed === total) {
        // all markers processed - hide the progress bar:
        progress.style.display = 'none';
    }
}

var markers = L.markerClusterGroup({chunkedLoading: true, chunkProgress: updateProgressBar});

var markerList = [];

for (var j = 0; j < impressions.length; j++) {
    var a = impressions[j]
    var marker = L.marker([a[0],a[1]]);
    
    markerList.push(marker);
    
    if (j % 10000 == 0) {
        console.log('loop milestone passed: ' + j);
    }
}

console.log('start clustering: ' + window.performance.now());
markers.addLayers(markerList);
map.addLayer(markers);
console.log('end clustering: ' + window.performance.now());