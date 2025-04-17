const activeLink = () => {
  const links = document.querySelectorAll("#menu-bar a");

  links.forEach(link => {
    link.classList.add("menu-link");

    if (window.location.pathname.includes(link.getAttribute("href"))) {
      link.classList.add("active-link");
    }
  });
}

const activeLocale = () => {
  const localesContainer = document.querySelector(".simple-locales-container");

  if (localesContainer) {
    const locales = localesContainer.querySelectorAll(".locale");
    const docLanguage = document.documentElement.lang;

    locales.forEach(locale => {
      if (docLanguage === locale.getAttribute("lang")) {
        locale.classList.add("active-locale");
      }
    })
  }
}

$(() => {
  activeLink();
  activeLocale();
})
