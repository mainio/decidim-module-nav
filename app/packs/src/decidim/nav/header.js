// import FocusGuard from "src/decidim/nav/focus_guard";
import FocusGuard from "src/decidim/focus_guard";

let headerFocusGuard = null;
const mediaQuery = window.matchMedia('(min-width: 1024px)');

/**
 * Enables or disables body scrolling.
 *
 * @param {Boolean} enabled Whether the body scroll is enabled (true) or
 *   disabled (false).
 */
const toggleBodyScroll = (enabled) => {
  if (enabled) {
    document.body.classList.remove("overflow-hidden");
  } else {
    document.body.classList.add("overflow-hidden");
  }
};

/**
 * Tells if the body scroll is currently disabled.
 *
 * @returns {Boolean} Whether body scroll is disabled or not.
 */
const bodyScrollDisabled = () => {
  return document.body.classList.contains("overflow-hidden");
};

/**
 * Toggles the focus guard within the header element when the menu is active.
 *
 * Note that the Decidim focus guard (i.e. `window.focusGuard`) only handles the
 * focus guard from the document borders, so the focus guard within the elements
 * has to be handled separately with another focus guard.
 *
 * @param {HTMLElement} header The header element.
 * @param {String} mode Layout mode (either "desktop" or "mobile").
 */
const toggleFocusGuard = (header, mode = "mobile") => {
  if (header.getAttribute("data-navbar-active")) {
    if (mode === "desktop") {
      headerFocusGuard.disable();
      window.focusGuard.disable();
    } else {
      headerFocusGuard.trap(header);
      window.focusGuard.trap(header);
    }
  } else if (!bodyScrollDisabled()) {
    headerFocusGuard.disable();
    window.focusGuard.disable();
  }
};

/**
 * Initializes the submenu items for desktop.
 */
const initializeSubmenus = () => {
  const itemsWithSubmenu = document.querySelectorAll("#menu-bar .menu__bar-element[data-submenu]");

  const toggleSubmenu = (menuItem, state) => {
    const toggle = menuItem.querySelector(".menu-element > .menu-element-caret");
    const submenu = menuItem.querySelector(".menu__bar-submenu");

    if (state === "open") {
      itemsWithSubmenu.forEach((item) => {
        if (item === menuItem) {
          return;
        }
        toggleSubmenu(item, "closed");
      })

      toggle.setAttribute("aria-expanded", true);
      submenu.setAttribute("data-state", "open");
    } else {
      toggle.setAttribute("aria-expanded", false);
      submenu.setAttribute("data-state", "closed");
    }
  };

  itemsWithSubmenu.forEach((menuItem) => {
    const menuEl = menuItem.querySelector(".menu-element");
    const toggle = menuEl.querySelector(":scope > .menu-element-caret");
    const submenu = menuItem.querySelector(".menu__bar-submenu");

    submenu.setAttribute("data-state", "closed");

    let mouseInside = false;
    menuItem.addEventListener("mouseenter", () => {
      mouseInside = true;
      toggleSubmenu(menuItem, "open");
    });
    menuItem.addEventListener("mouseleave", () => {
      mouseInside = false;
      if (toggle.getAttribute("data-active") === "true") {
        return;
      }
      toggleSubmenu(menuItem, "closed");
    });
    toggle.addEventListener("mouseenter", () => {
      if (toggle.getAttribute("data-active") === "true") {
        return;
      }

      toggleSubmenu(menuItem, "closed");
    });
    toggle.addEventListener("mouseleave", () => {
      if (mouseInside) {
        toggleSubmenu(menuItem, "open");
      }
    });
    toggle.addEventListener("click", () => {
      if (submenu.getAttribute("data-state") === "open") {
        toggleSubmenu(menuItem, "closed");
        toggle.removeAttribute("data-active");
      } else {
        toggleSubmenu(menuItem, "open");
        toggle.setAttribute("data-active", true);
      }
    });
  });

  document.addEventListener("click", (ev) => {
    if (ev.target.closest(".menu__bar-element[data-submenu]")) {
      return;
    }

    itemsWithSubmenu.forEach((item) => toggleSubmenu(item, "closed"));
  });
};

/**
 * Initializes the submenu items for mobile.
 */
const initializeMobileSubmenus = () => {
  const mobileItemsWithSubmenu = document.querySelectorAll("#mobile-menu .menu__bar-mobile[data-submenu]");

  mobileItemsWithSubmenu.forEach((menuItem) => {
    const menuEl = menuItem.querySelector(".menu-element-mobile");
    const toggle = menuEl.querySelector(":scope > .menu-element-caret");
    const submenu = menuItem.querySelector(".menu__bar-submenu-mobile");

    menuEl.addEventListener("click", () => {
      if (submenu.getAttribute("data-state") === "open") {
        toggle.setAttribute("aria-expanded", false);
        submenu.setAttribute("data-state", "closed");
        toggle.removeAttribute("data-active");
      } else {
        toggle.setAttribute("aria-expanded", true);
        submenu.setAttribute("data-state", "open");
        toggle.setAttribute("data-active", true);
      }
    });
  });
};

/**
 * Handles the mobile navbar toggles for opening/closing the main navigation and
 * the account navigation elements.
 */
const navbarToggles = (header) => {
  header.querySelectorAll("[data-navbar-toggle]").forEach((toggle) => {
    const target = toggle.getAttribute("data-navbar-toggle");

    toggle.setAttribute("aria-expanded", false);
    toggle.addEventListener("click", () => {
      const current = header.getAttribute("data-navbar-active");

      // Set other toggles as not expanded
      header.querySelectorAll("[data-navbar-toggle]").forEach((otherToggle) => {
        if (otherToggle === toggle) {
          return;
        }
        otherToggle.setAttribute("aria-expanded", false);
      });

      if (target === current) {
        toggleBodyScroll(true);
        header.removeAttribute("data-navbar-active");
        toggle.setAttribute("aria-expanded", false);
        toggleFocusGuard(header);
      } else {
        toggleBodyScroll(false);
        header.setAttribute("data-navbar-active", target);
        toggle.setAttribute("aria-expanded", true);
        toggleFocusGuard(header);
      }
    });
  });
};

const handleLayoutChange = (size) => {
  if (!size.matches) {
    return;
  }

  const header = document.querySelector("header");
  header.removeAttribute("data-navbar-active");
  header.querySelectorAll("[data-navbar-toggle]").forEach((toggle) => {
    toggle.setAttribute("aria-expanded", false);
  });

  toggleBodyScroll(true);
  toggleFocusGuard(header, "desktop");
};


document.addEventListener("DOMContentLoaded", () => {
  if (!document.getElementById("main-bar")) {
    return;
  }

  const header = document.querySelector("header");

  initializeSubmenus();
  initializeMobileSubmenus();
  navbarToggles(header);
  mediaQuery.addEventListener("change", handleLayoutChange);

  headerFocusGuard = new FocusGuard(header);
});
