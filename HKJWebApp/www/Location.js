function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else { 
    alert("Please Enable Geolocation for Maps");
  }
}

function showPosition(position) {
  Shiny.onInputChange("location",{lon: position.coords.longitude,lat:position.coords.latitude});
}