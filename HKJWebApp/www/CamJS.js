

function camJS(namespace){
  var video = document.getElementById(namespace+'video');
  var snap = document.getElementById(namespace+'snap');
  var canvas = document.getElementById(namespace+'canvas');
  if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
    // Not adding `{ audio: true }` since we only want video now
    navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
    video.srcObject = stream;
    video.play();
      
    });
  }
  var context = canvas.getContext('2d');
  // Trigger photo take
  snap.addEventListener('click', function() {
  context.drawImage(video, 0, 0, video.width,video.height);
  var imgAsDataURL = canvas.toDataURL();
  var message = {image: imgAsDataURL, width: video.videoWidth, height: video.videoHeight};
  Shiny.onInputChange(namespace+'image',message);
  });
}