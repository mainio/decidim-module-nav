const activeLink = () => {
  const links = document.querySelectorAll("#menu-bar a");

  links.forEach(link => {
    link.classList.add("menu-link");

    if (window.location.pathname === link.getAttribute("href")) {
      link.classList.add("active-link");
    }
  });
}

$(() => {
  activeLink();
})
