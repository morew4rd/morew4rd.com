function isLight() {
  return localStorage.getItem("light-mode");
}


function toggleRootClass() {
  document.querySelector(":root").classList.toggle("light");
}

function toggleLocalStorageItem() {
  if (isLight()) {
    localStorage.removeItem("light-mode");
  } else {
    localStorage.setItem("light-mode", "set");
  }
}


document.querySelector(".theme-icon").addEventListener("click", () => {
  toggleLocalStorageItem();
  toggleRootClass();
});

// light mode by defult
if (!isLight()) {
  toggleRootClass();
}
