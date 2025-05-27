import FocusGuard from "src/decidim/focus_guard"

const activeLink = () => {
  const highLightLink = (selector) => {
    const links = document.querySelectorAll(`${selector} a`);

    links.forEach(link => link.classList.add("menu-link"));

    const currentPath = window.location.pathname;
    let closestMatch = null;
    let closestMatchLength = 0;

    links.forEach(link => {
      const href = link.getAttribute("href");

      if (currentPath === href || (href !== "/" && currentPath.startsWith(href))) {
        if (href.length > closestMatchLength) {
          closestMatch = link;
          closestMatchLength = href.length;
        }
      }
    })

    if (closestMatch) {
      closestMatch.classList.add("active-link");
    }
  }

  // desktop
  highLightLink("#menu-bar");

  // mobile
  highLightLink("#mobile-menu");
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

let focusGuard;

const initializeAccountMenu = () => {
  const mobileAccount = document.getElementById("trigger-dropdown-account-mobile")
  const accountMenu = document.getElementById("dropdown-menu-account-mobile");
  const focusWrapper = document.getElementById("focus-wrapper-mobile");

  if (mobileAccount) {
    mobileAccount.addEventListener("click", () => {
      const isHidden = accountMenu.getAttribute("aria-hidden") === "false";
      document.body.classList.toggle("overflow-hidden", isHidden);

      if (!isHidden) {
        focusGuard.trap(focusWrapper);

        const focusable = getFocusableElements(focusWrapper, "#toggle-mobile-menu");

        if (focusable.length > 0) {
          focusable[0].focus();
        }
      } else {
        focusGuard.disable();
      }
    });

    focusWrapper.addEventListener("keydown", (e) => {
      if (e.key !== "Tab" || accountMenu.getAttribute("aria-hidden") === "true") return;

      const focusable = getFocusableElements(focusWrapper, "#toggle-mobile-menu");

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
    })
  }
}

const getFocusableElements = (focusWrapper, ignored) => {
  return [...focusWrapper.querySelectorAll(
    `a[href], button:not([disabled]):not(${ignored}), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])`
  )].filter(el =>
    el.offsetWidth > 0 &&
    el.offsetHeight > 0 &&
    !el.classList.contains("focusguard") &&
    !(el.tagName === "A" && el.getAttribute("aria-label") === "Go to front page")
  );
};


const initializeMobileMenu = () => {
  const mobileMenuButton = document.getElementById("toggle-mobile-menu");
  const mainBar = document.getElementById("main-bar");
  const mobileMenu = document.getElementById("mobile-menu");

  if (mainBar) {

    const focusWrapper = document.createElement("div");
    focusWrapper.setAttribute("id", "focus-wrapper-mobile");
    focusWrapper.style.position = "relative";

    mainBar.parentNode.insertBefore(focusWrapper, mainBar);
    focusWrapper.appendChild(mainBar);
    focusWrapper.appendChild(mobileMenu);

    focusGuard = new FocusGuard(focusWrapper);

    mobileMenuButton.addEventListener("click", () => {
      const isHidden = mobileMenu.classList.toggle("hidden");
      document.body.classList.toggle("overflow-hidden", !isHidden);

      const openIcon = mobileMenuButton.dataset.iconOpen;
      const closeIcon = mobileMenuButton.dataset.iconClose;

      if (!isHidden) {
        focusGuard.trap(focusWrapper);
        mobileMenuButton.innerHTML = closeIcon;

        const focusable = getFocusableElements(focusWrapper, "#trigger-dropdown-account-mobile");

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

      const focusable = getFocusableElements(focusWrapper, "#trigger-dropdown-account-mobile");

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
}

const hideMenus = () => {
  const submenuCarets = document.querySelectorAll("[data-toggle-target]");

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
    });
  });
}

const handleSubmenu = () => {
  const submenuCarets = document.querySelectorAll("[data-toggle-target]");

  submenuCarets.forEach(caret => {
    const caretIcon = caret.querySelector("svg");

    caret.addEventListener("click", (e) => {
      e.stopPropagation();
      caretIcon.classList.toggle("rotate-180");

      const submenuId = caret.getAttribute("data-toggle-target");
      const submenu = document.getElementById(submenuId);

      if (!submenu) return;

      submenuCarets.forEach(otherCaret => {
        const caretIcon = otherCaret.querySelector("svg");

        if (otherCaret === caret) return;

        const otherSubmenuId = otherCaret.getAttribute("data-toggle-target");
        const otherSubmenu = document.getElementById(otherSubmenuId);

        if (!otherSubmenu) return;

        caretIcon.classList.remove("rotate-180");
        otherCaret.setAttribute("aria-expanded", "false");
        otherSubmenu.style.display = "none";
      });

      const isExpanded = caret.getAttribute("aria-expanded") === "true";
      caret.setAttribute("aria-expanded", (!isExpanded).toString());
      submenu.style.display = isExpanded ? "none" : "block";
    });
  });
}

const mediaQuery = window.matchMedia('(min-width: 1024px)');

const handleScreenSize = (size) => {
  const mobileMenuButton = document.getElementById("toggle-mobile-menu");
  const mobileMenu = document.getElementById("mobile-menu");
  const mobileAccount = document.getElementById("trigger-dropdown-account-mobile")
  if (mobileMenuButton) {
    const openIcon = mobileMenuButton.dataset.iconOpen;

    if (size.matches) {
      if (mobileAccount && mobileAccount.getAttribute("aria-expanded") === "true") {
        mobileAccount.dispatchEvent(new Event("click"))
      }

      if (!mobileMenu.classList.contains("hidden")) {
        mobileMenu.classList.add("hidden");
        mobileMenuButton.innerHTML = openIcon;
      }

      document.body.classList.remove("overflow-hidden");
    } else {
      return;
    }
  }
}

$(() => {
  activeLink();
  activeLocale();
  initializeMobileMenu();
  initializeAccountMenu();
  handleSubmenu();
  handleScreenSize(mediaQuery);
  hideMenus();
  mediaQuery.addEventListener("change", handleScreenSize);
})
