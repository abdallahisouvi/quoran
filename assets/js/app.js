const surahs = [
  "الفاتحة","البقرة","آل عمران","النساء","المائدة","الأنعام","الأعراف","الأنفال","التوبة","يونس",
  "هود","يوسف","الرعد","إبراهيم","الحجر","النحل","الإسراء","الكهف","مريم","طه",
  "الأنبياء","الحج","المؤمنون","النور","الفرقان","الشعراء","النمل","القصص","العنكبوت","الروم",
  "لقمان","السجدة","الأحزاب","سبأ","فاطر","يس","الصافات","ص","الزمر","غافر",
  "فصلت","الشورى","الزخرف","الدخان","الجاثية","الأحقاف","محمد","الفتح","الحجرات","ق",
  "الذاريات","الطور","النجم","القمر","الرحمن","الواقعة","الحديد","المجادلة","الحشر","الممتحنة",
  "الصف","الجمعة","المنافقون","التغابن","الطلاق","التحريم","الملك","القلم","الحاقة","المعارج",
  "نوح","الجن","المزمل","المدثر","القيامة","الإنسان","المرسلات","النبأ","النازعات","عبس",
  "التكوير","الانفطار","المطففين","الانشقاق","البروج","الطارق","الأعلى","الغاشية","الفجر","البلد",
  "الشمس","الليل","الضححى","الشرح","التين","العلق","القدر","البينة","الزلزلة","العاديات",
  "القارعة","التكاثر","العصر","الهمزة","الفيل","قريش","الماعون","الكوثر","الكافرون","النصر",
  "المسد","الإخلاص","الفلق","الناس"
];

const audio = new Audio();
let currentIndex = 0;
let isPlaying = false;

function audioPath(i) {
  return `assets/audios/${String(i + 1).padStart(3, "0")}.mp3`;
}

/* بناء قائمة السور */
const list = document.getElementById("surahList");
surahs.forEach((name, i) => {
  const li = document.createElement("li");
  li.innerHTML = `<span>${i + 1}</span> ${name}`;
  li.onclick = () => playSurah(i);
  list.appendChild(li);
});

function playSurah(i) {
  currentIndex = i;
  audio.src = audioPath(i);
  audio.play();
  isPlaying = true;
  document.getElementById("surahName").innerText = surahs[i];
}

function togglePlay() {
  if (!audio.src) {
    playSurah(currentIndex);
    return;
  }
  if (isPlaying) {
    audio.pause();
  } else {
    audio.play();
  }
  isPlaying = !isPlaying;
}

function nextSurah() {
  currentIndex = (currentIndex + 1) % surahs.length;
  playSurah(currentIndex);
}

function prevSurah() {
  currentIndex = (currentIndex - 1 + surahs.length) % surahs.length;
  playSurah(currentIndex);
}
audio.addEventListener("ended", () => {
  if (currentIndex < surahs.length - 1) {
    currentIndex++;
    playSurah(currentIndex);
  }
});
