window.addEventListener('load', function() {
  const input = document.getElementById('search-input');
  const resultsContainer = document.getElementById('search-results');
  const template = document.getElementById('search-results-template').innerHTML;

  let fuse;
  let index = [];

  // 加载搜索索引
  fetch('/index.json')
    .then(response => response.json())
    .then(data => {
      index = data.map(item => ({
        title: item.title,
        content: item.content,
        permalink: item.permalink,
        date: item.date,
        summary: item.summary || item.content.substring(0, 200) + '...'
      }));

      const options = {
        keys: ['title', 'content'],
        threshold: 0.3,
        minMatchCharLength: 2
      };

      fuse = new Fuse(index, options);
    });

  // 搜索输入处理
  input.addEventListener('input', debounce(function(e) {
    const query = e.target.value.trim();

    if (!query) {
      resultsContainer.innerHTML = '';
      return;
    }

    const results = fuse.search(query);
    displayResults(results);
  }, 300));

  function displayResults(results) {
    if (!results.length) {
      resultsContainer.innerHTML = '<p>没有找到匹配的内容</p>';
      return;
    }

    const rendered = Mustache.render(template, {
      results: results.map(result => result.item)
    });

    resultsContainer.innerHTML = rendered;
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
