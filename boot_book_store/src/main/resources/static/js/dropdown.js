document.addEventListener("DOMContentLoaded", () => {
    const dd = document.querySelector(".admin-dropdown");
    const txt = dd.querySelector(".admin-text");

    txt.addEventListener("click", e => {
        e.stopPropagation();
        dd.classList.toggle("open");
    });

    document.addEventListener("click", () => dd.classList.remove("open"));
});