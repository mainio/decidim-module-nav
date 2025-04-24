const activeLink = () => {
  // For desktop
  const links = document.querySelectorAll("#menu-bar a");

  links.forEach(link => {
    link.classList.add("menu-link");

    if (window.location.pathname.includes(link.getAttribute("href"))) {
      link.classList.add("active-link");
    }
  });

  // For mobile
  const mobileLinks = document.querySelectorAll("#mobile-menu a");

  mobileLinks.forEach(link => {
    link.classList.add("menu-link");

    if (window.location.pathname.includes(link.getAttribute("href"))) {
      link.classList.add("active-link");
    }
  })
}

const activeLocale = () => {
  const localesContainers = document.querySelectorAll(".simple-locales-container");

  localesContainers.forEach(localesContainer => {
    if (localesContainer) {
      const locales = localesContainer.querySelectorAll(".locale");
      const docLanguage = document.documentElement.lang;

      locales.forEach(locale => {
        if (docLanguage === locale.getAttribute("lang")) {
          locale.classList.add("active-locale");
        }
      })
    }
  })
}

const initializeMobileMode = () => {
  const mobileMenuButton = document.getElementById("toggle-mobile-menu");
  const mobileMenu = document.getElementById("mobile-menu");

  mobileMenuButton.addEventListener("click", () => {
    const isHidden = mobileMenu.classList.toggle("hidden");

    document.body.classList.toggle("overflow-hidden", !isHidden);
  })

  document.querySelectorAll("[data-toggle-target]").forEach(caret => {
    caret.addEventListener("click", (e) => {
      e.stopPropagation();
      caret.classList.toggle("rotate-180")
      const targetId = caret.getAttribute("data-toggle-target");
      const submenu = document.getElementById(targetId);

      if (submenu) {
        if (submenu.style.display === "block") {
          submenu.style.display = "none";
        } else {
          submenu.style.display = "block";
        }
      }
    });
  });
}

$(() => {
  activeLink();
  activeLocale();
  initializeMobileMode();
})
