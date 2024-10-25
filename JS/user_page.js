// Dynamically load the navbar template into the placeholder
document.addEventListener('DOMContentLoaded', () => {
    const navbarPlaceholder = document.getElementById('navbar-placeholder');
    fetch('navbar.jsp')
        .then(response => response.text())
        .then(data => {
            navbarPlaceholder.innerHTML = data;
        })
        .catch(error => console.error('Error loading navbar:', error));
});

function loadContent(page) {
    const contentArea = document.getElementById('content-area');
    const links = document.querySelectorAll('.sidebar ul li a');

    // Remove 'active' class from all sidebar links
    links.forEach(link => link.classList.remove('active'));

    // Add 'active' class to the clicked link
    const activeLink = Array.from(links).find(link =>
        link.getAttribute('onclick').includes(page)
    );
    if (activeLink) activeLink.classList.add('active');

    // Load corresponding content based on the page parameter
    switch (page) {
        case 'home':
            contentArea.innerHTML = `
                <h1>HOME</h1>
                <p>Pollify's home content.</p>
            `;
            break;
        case 'introduction':
            contentArea.innerHTML = `
                <h1>Vote</h1>
                <p>JavaScript is the programming language of the Web. It is easy to learn.</p>
            `;
            break;
        case 'output':
            contentArea.innerHTML = `
                <h1>Candidate</h1>
                <p>JavaScript can display data in various ways, such as writing to the HTML output.</p>
            `;
            break;
        case 'syntax':
            contentArea.innerHTML = `
                <h1>Result</h1>
                <p>JavaScript syntax is the set of rules for constructing programs.</p>
            `;
            break;
        case 'functions':
            contentArea.innerHTML = `
                <h1>JavaScript Functions</h1>
                <p>Functions in JavaScript perform specific tasks when called.</p>
            `;
            break;
    }
}
