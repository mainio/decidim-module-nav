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
  const adminBar = document.getElementById("admin-bar");
  const mainBar = document.getElementById("main-bar");
  const mobileMenu = document.getElementById("mobile-menu");

  const focusWrapper = document.createElement("div");
  focusWrapper.setAttribute("id", "focus-wrapper");
  focusWrapper.style.position = "relative";

  const menus = adminBar ? [adminBar, mainBar] : [mainBar];
  const firstMenu = adminBar || mainBar;

  firstMenu.parentNode.insertBefore(focusWrapper, firstMenu);
  menus.forEach(menu => focusWrapper.appendChild(menu));
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

    if (!isHidden) {
      focusGuard.trap(focusWrapper);

      const focusable = getFocusableElements();

      if (focusable.length > 0) {
        focusable[0].focus();
      }
    } else {
      focusGuard.disable();
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

  document.querySelectorAll("[data-toggle-target]").forEach(caret => {
    caret.addEventListener("click", (e) => {
      e.stopPropagation();
      caret.classList.toggle("rotate-180");

      const targetId = caret.getAttribute("data-toggle-target");
      const submenu = document.getElementById(targetId);

      if (submenu) {
        const isExpanded = caret.getAttribute("aria-expanded") === "true";

        submenu.style.display = isExpanded ? "none" : "block";

        caret.setAttribute("aria-expanded", (!isExpanded).toString());
      }
    });
  });
}

$(() => {
  activeLink();
  activeLocale();
  initializeMobileMode();
})
