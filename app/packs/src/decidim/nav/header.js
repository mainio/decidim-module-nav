import FocusGuard from "src/decidim/focus_guard"

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
  const mainBar = document.getElementById("main-bar");
  const mobileMenu = document.getElementById("mobile-menu");

  const focusWrapper = document.createElement("div");
  focusWrapper.setAttribute("id", "focus-wrapper");
  focusWrapper.style.position = "relative";

  mainBar.parentNode.insertBefore(focusWrapper, mainBar);
  focusWrapper.appendChild(mainBar);
  focusWrapper.appendChild(mobileMenu);

  const focusGuard = new FocusGuard(focusWrapper);

  const getFocusableElements = () => {
    return [...focusWrapper.querySelectorAll(
      'a[href], button:not([disabled]):not(#toggle-mobile-menu), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )].filter(el =>
      el.offsetWidth > 0 &&
      el.offsetHeight > 0 &&
      !el.classList.contains("focusguard")
    );
  };

  mobileMenuButton.addEventListener("click", () => {
    const isHidden = mobileMenu.classList.toggle("hidden");
    document.body.classList.toggle("overflow-hidden", !isHidden);

    const openIcon = mobileMenuButton.dataset.iconOpen;
    const closeIcon = mobileMenuButton.dataset.iconClose;

    if (!isHidden) {
      focusGuard.trap(focusWrapper);
      mobileMenuButton.innerHTML = closeIcon;

      const focusable = getFocusableElements();

      if (focusable.length > 0) {
        focusable[0].focus();
      }
    } else {
      focusGuard.disable();
      mobileMenuButton.innerHTML = openIcon;
    }
  });

  focusWrapper.addEventListener("keydown", (e) => {
    if (e.key !== "Tab" || mobileMenu.classList.contains("hidden")) return;

    const focusable = getFocusableElements();

    if (focusable.length === 0) return;

    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  });
}

const handleSubmenu = () => {
  const submenuCarets = document.querySelectorAll("[data-toggle-target]");

  submenuCarets.forEach(caret => {
    caret.addEventListener("click", (e) => {
      e.stopPropagation();
      caret.classList.toggle("rotate-180");

      const submenuId = caret.getAttribute("data-toggle-target");
      const submenu = document.getElementById(submenuId);

      if (!submenu) return;

      submenuCarets.forEach(otherCaret => {
        if (otherCaret === caret) return;

        const otherSubmenuId = otherCaret.getAttribute("data-toggle-target");
        const otherSubmenu = document.getElementById(otherSubmenuId);

        if (!otherSubmenu) return;

        otherCaret.classList.remove("rotate-180");
        otherCaret.setAttribute("aria-expanded", "false");
        otherSubmenu.style.display = "none";
      });

      const isExpanded = caret.getAttribute("aria-expanded") === "true";
      caret.setAttribute("aria-expanded", (!isExpanded).toString());
      submenu.style.display = isExpanded ? "none" : "block";
    });
  });

  document.addEventListener("click", (e) => {
    submenuCarets.forEach(caret => {
      const submenuId = caret.getAttribute("data-toggle-target");
      const submenu = document.getElementById(submenuId);

      if (!submenu) return;

      const isExpanded = caret.getAttribute("aria-expanded") === "true";

      if (isExpanded && !caret.contains(e.target) && !submenu.contains(e.target)) {
        caret.classList.toggle("rotate-180");
        caret.setAttribute("aria-expanded", "false");
        submenu.style.display = "none";
      }
    })
  });
}

$(() => {
  activeLink();
  activeLocale();
  initializeMobileMode();
  handleSubmenu();
})
