window.addEventListener('load', function() {
  const input = document.getElementById('search-input');
  const resultsContainer = document.getElementById('search-results');

  let index = [];

  fetch('/index.json')
    .then(response => response.json())
    .then(data => {
      index = data;
    });

  input.addEventListener('input', debounce(function(e) {
    const query = e.target.value.trim().toLowerCase();

    if (!query) {
      resultsContainer.innerHTML = '';
      return;
    }

    const results = index.filter(item => 
      item.title.toLowerCase().includes(query) || 
      item.content.toLowerCase().includes(query)
    );

    displayResults(results);
  }, 300));

  function displayResults(results) {
    if (!results.length) {
      resultsContainer.innerHTML = '<p>没有找到匹配的内容</p>';
      return;
    }

    const html = results.map(item => `
      <article class="post-entry">
        <header class="entry-header">
          <h2>${escapeHtml(item.title)}</h2>
        </header>
        ${item.summary ? `<div class="entry-content"><p>${escapeHtml(item.summary)}</p></div>` : ''}
        <footer class="entry-footer">
          <span>${escapeHtml(item.date)}</span>
        </footer>
        <a class="entry-link" aria-label="post link to ${escapeHtml(item.title)}" href="${escapeHtml(item.permalink)}"></a>
      </article>
    `).join('');

    resultsContainer.innerHTML = html;
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
});
