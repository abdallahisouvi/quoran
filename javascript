const audio = new Audio();
let currentSurah = 0;

function playSurah(index) {
  currentSurah = index;
  audio.src = getAudioPath(index);
  audio.play();
  document.getElementById("surahName").innerText = surahs[index];
}
