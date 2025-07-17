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

      if (href && (currentPath === href || (href !== "/" && currentPath.startsWith(href)))) {
        if (href.length > closestMatchLength) {
          closestMatch = link;
          closestMatchLength = href.length;
        }
      }
    })

    if (closestMatch) {
      closestMatch.classList.add("active-link");

      const menuElement = closestMatch.closest(".menu-element");

      if (menuElement) {
        const caret = menuElement.querySelector(".menu-element-caret");

        if (caret) {
          caret.classList.add("active-caret");
        }
      }

      const parent = closestMatch.closest(".menu__bar-submenu");

      if (parent) {
        const parentWrapper = parent.closest(".menu__bar-element");
        const parentLink = parentWrapper.querySelector(".menu-element > a");
        const parentCaret = parentWrapper.querySelector(".menu-element-caret");

        parentLink.classList.add("active-link");
        parentCaret.classList.add("active-caret");
      }
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

const hideMobileMenu = (mobileMenu) => {
  const mobileMenuButton = document.getElementById("toggle-mobile-menu");

  const iconSpan = mobileMenuButton.querySelector(".mobile-menu-icon");
  const labelSpan = mobileMenuButton.querySelector(".mobile-menu-label");

  const openIcon = mobileMenuButton.dataset.iconOpen;
  const openLabel = mobileMenuButton.dataset.labelOpen;

  mobileMenu.classList.add("hidden");
  iconSpan.innerHTML = openIcon;
  labelSpan.innerHTML = openLabel;
}

const changeMobileMenuIcon = () => {
  const iconContainer = document.querySelector(".mobile-menu-icon");

  if(!iconContainer) return;

  const menuIcon = iconContainer.querySelector(".icon-menu");
  const closeIcon = iconContainer.querySelector(".icon-close");

  const menuVisible = !menuIcon.classList.contains("hidden");

  menuIcon.classList.toggle("hidden", menuVisible);
  closeIcon.classList.toggle("hidden", !menuVisible);
}

const changeAccountIcon = () => {
  const iconContainer = document.querySelector(".mobile-account-icon");

  if(!iconContainer) return;

  const userIcon = iconContainer.querySelector(".icon-user");
  const closeIcon = iconContainer.querySelector(".icon-close");

  const userVisible = !userIcon.classList.contains("hidden");

  userIcon.classList.toggle("hidden", userVisible);
  closeIcon.classList.toggle("hidden", !userVisible);
}

const hideAccountMenu = (accountMenuTrigger) => {
  const notification = document.querySelector(".account-notification");
  const labelSpan = accountMenuTrigger.querySelector(".mobile-account-label");
  const openLabel = accountMenuTrigger.dataset.labelOpen;

  changeAccountIcon();
  labelSpan.innerHTML = openLabel;
  notification.classList.add("main-bar__notification");
}

const initializeAccountMenu = () => {
  const mobileAccount = document.getElementById("trigger-dropdown-account-mobile");
  const accountMenu = document.getElementById("dropdown-menu-account-mobile");
  const focusWrapper = document.getElementById("focus-wrapper-mobile");
  const mobileMenu = document.getElementById("mobile-menu");

  if (mobileAccount) {
    const notification = mobileAccount.querySelector(".main-bar__notification");

    if (notification) {
      notification.classList.add("account-notification");
    }

    mobileAccount.addEventListener("click", () => {
      const labelSpan = mobileAccount.querySelector(".mobile-account-label");

      const closeLabel = mobileAccount.dataset.labelClose;

      if (!mobileMenu.classList.contains("hidden")) {
        hideMobileMenu(mobileMenu);
      }

      const visible = accountMenu.getAttribute("aria-hidden") === "false";
      document.body.classList.toggle("overflow-hidden", visible);

      if (!visible) {
        focusGuard.disable();
        hideAccountMenu(mobileAccount);
      } else {
        focusGuard.trap(focusWrapper);
        changeAccountIcon();
        labelSpan.innerHTML = closeLabel;

        notification.classList.remove("main-bar__notification");

        const focusable = getFocusableElements(focusWrapper, "#toggle-mobile-menu");

        if (focusable.length > 0) {
          focusable[0].focus();
        }
      }
    });

    focusWrapper.addEventListener("keydown", (e) => {
      if (e.key === "Escape") { focusGuard.disable(); document.body.classList.toggle("overflow-hidden", false); }
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
    !(el.tagName === "A" && el.closest(".main-bar__logo"))
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

      const labelSpan = mobileMenuButton.querySelector(".mobile-menu-label");

      const openLabel = mobileMenuButton.dataset.labelOpen;
      const closeLabel = mobileMenuButton.dataset.labelClose;

      if (!isHidden) {
        focusGuard.trap(focusWrapper);
        changeMobileMenuIcon();
        labelSpan.innerHTML = closeLabel;

        const focusable = getFocusableElements(focusWrapper, "#trigger-dropdown-account-mobile");

        if (focusable.length > 0) {
          focusable[0].focus();
        }
      } else {
        focusGuard.disable();
        changeMobileMenuIcon();
        labelSpan.innerHTML = openLabel;
      }
    });

    focusWrapper.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        focusGuard.disable();
        document.body.classList.toggle("overflow-hidden", false);
        mobileMenu.classList.toggle("hidden");
      }
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

    // handle accountmenu icon change and mobilemenu close

    const mobileMenuButton = document.getElementById("toggle-mobile-menu");
    const mobileMenu = document.getElementById("mobile-menu");

    const accountTrigger = document.getElementById("trigger-dropdown-account-mobile");
    const accountMenu = document.getElementById("dropdown-menu-account-mobile");

    if (accountMenu.getAttribute("aria-hidden") === "false" && !accountTrigger.contains(e.target) && !accountMenu.contains(e.target)) {
      focusGuard.disable();
      document.body.classList.toggle("overflow-hidden", false);

      hideAccountMenu(accountTrigger);
    }

    if (!mobileMenu.classList.contains("hidden") && !mobileMenuButton.contains(e.target) && !mobileMenu.contains(e.target)) {
      focusGuard.disable();

      mobileMenu.classList.toggle("hidden");
      document.body.classList.toggle("overflow-hidden", false);

      const labelSpan = mobileMenuButton.querySelector(".mobile-menu-label");
      const openLabel = mobileMenuButton.dataset.labelOpen;
      changeMobileMenuIcon();
      labelSpan.innerHTML = openLabel;
    }
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

const handleAccountMenu = () => {
  const header = document.querySelector("header");
  const dropdown = document.querySelector(".dropdown-menu-account-mobile");

  if (header && dropdown) {
    const headerHeight = header.offsetHeight;
    dropdown.style.top = `${headerHeight}px`;
  }
}

const mediaQuery = window.matchMedia('(min-width: 1024px)');

const handleScreenSize = (size) => {
  const mobileMenuButton = document.getElementById("toggle-mobile-menu");
  const mobileMenu = document.getElementById("mobile-menu");

  const mobileAccount = document.getElementById("trigger-dropdown-account-mobile");

  if (mobileAccount) {
    handleAccountMenu();
  }

  if (mobileMenuButton) {
    if (size.matches) {
      if (mobileAccount && mobileAccount.getAttribute("aria-expanded") === "true") {
        mobileAccount.dispatchEvent(new Event("click"))
      }

      if (!mobileMenu.classList.contains("hidden")) {
        hideMobileMenu(mobileMenu);
      }

      document.body.classList.remove("overflow-hidden");
    } else {
      return;
    }
  }
}

$(() => {
  if (document.getElementById("main-bar")) {
    activeLink();
    activeLocale();
    initializeMobileMenu();
    initializeAccountMenu();
    handleSubmenu();
    handleScreenSize(mediaQuery);
    hideMenus();
    mediaQuery.addEventListener("change", handleScreenSize);
  }
})
