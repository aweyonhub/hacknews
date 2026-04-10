/* HackNews Digest — 客户端搜索（Fuse.js 懒加载）*/
(function () {
  'use strict';

  var TOGGLE  = document.getElementById('searchToggle');
  var OVERLAY = document.getElementById('searchOverlay');
  var INPUT   = document.getElementById('searchInput');
  var RESULTS = document.getElementById('searchResults');
  var CLOSE   = document.getElementById('searchClose');

  var fuse   = null;
  var loaded = false;

  /* ---- 初始化：懒加载 Fuse.js + 搜索索引 ---- */
  function initSearch() {
    if (loaded) return Promise.resolve();
    loaded = true;

    var fuseUrl = 'https://cdn.jsdelivr.net/npm/fuse.js@7.1.0/dist/fuse.min.js';

    var loadFuse = window.Fuse
      ? Promise.resolve()
      : loadScript(fuseUrl);

    return loadFuse.then(function () {
      return fetch(BASE_URL + 'index.json');
    }).then(function (res) {
      return res.json();
    }).then(function (data) {
      fuse = new Fuse(data, {
        keys: [
          { name: 'title',   weight: 0.7 },
          { name: 'content', weight: 0.3 }
        ],
        includeMatches:    true,
        minMatchCharLength: 1,
        threshold:          0.4
      });
    }).catch(function () {
      RESULTS.innerHTML = '<div class="search-empty">搜索索引加载失败，请检查网络</div>';
    });
  }

  function loadScript(src) {
    return new Promise(function (resolve, reject) {
      var s = document.createElement('script');
      s.src = src;
      s.onload  = resolve;
      s.onerror = reject;
      document.head.appendChild(s);
    });
  }

  /* ---- 开关 ---- */
  function openSearch() {
    OVERLAY.classList.add('open');
    OVERLAY.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    INPUT.focus();
    initSearch();
  }

  function closeSearch() {
    OVERLAY.classList.remove('open');
    OVERLAY.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    INPUT.value = '';
    RESULTS.innerHTML = '<div class="search-hint">输入关键词开始搜索</div>';
  }

  /* ---- 搜索执行 ---- */
  function doSearch(query) {
    if (!fuse) {
      RESULTS.innerHTML = '<div class="search-hint">正在初始化搜索索引…</div>';
      return;
    }
    if (!query.trim()) {
      RESULTS.innerHTML = '<div class="search-hint">输入关键词开始搜索</div>';
      return;
    }

    var results = fuse.search(query, { limit: 12 });
    if (!results.length) {
      RESULTS.innerHTML = '<div class="search-empty">没有找到"' + escapeHTML(query) + '"相关内容</div>';
      return;
    }

    RESULTS.innerHTML = results.map(function (r) {
      var item    = r.item;
      var matches = r.matches;
      var title   = hlt(item.title,   matches, 'title');
      var snippet = hlt((item.content || '').slice(0, 100), matches, 'content');
      var date    = item.date ? '<span class="si-date">' + item.date + '</span>' : '';
      return '<a href="' + item.url + '" class="search-item">'
        + '<div class="si-title">' + title + '</div>'
        + '<div class="si-meta">' + date + (snippet ? snippet + '…' : '') + '</div>'
        + '</a>';
    }).join('');
  }

  /* ---- 工具：高亮匹配字符 ---- */
  function hlt(text, matches, key) {
    if (!matches || !text) return escapeHTML(text || '');
    var m = null;
    for (var i = 0; i < matches.length; i++) {
      if (matches[i].key === key) { m = matches[i]; break; }
    }
    if (!m || !m.indices || !m.indices.length) return escapeHTML(text);

    var chars  = Array.from(text);
    var result = '';
    var last   = 0;
    var indices = m.indices;
    for (var j = 0; j < indices.length; j++) {
      var s = indices[j][0];
      var e = indices[j][1];
      result += escapeHTML(chars.slice(last, s).join(''));
      result += '<em>' + escapeHTML(chars.slice(s, e + 1).join('')) + '</em>';
      last = e + 1;
    }
    result += escapeHTML(chars.slice(last).join(''));
    return result;
  }

  function escapeHTML(str) {
    return (str || '').replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  /* ---- 事件绑定 ---- */
  if (TOGGLE)  TOGGLE.addEventListener('click', openSearch);
  if (CLOSE)   CLOSE.addEventListener('click', closeSearch);
  if (OVERLAY) OVERLAY.addEventListener('click', function (e) {
    if (e.target === OVERLAY) closeSearch();
  });
  if (INPUT) INPUT.addEventListener('input', function (e) {
    doSearch(e.target.value);
  });

  document.addEventListener('keydown', function (e) {
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      OVERLAY && OVERLAY.classList.contains('open') ? closeSearch() : openSearch();
    }
    if (e.key === 'Escape' && OVERLAY && OVERLAY.classList.contains('open')) {
      closeSearch();
    }
  });
})();

/* ---- 主题切换 ---- */
(function () {
  var btn = document.getElementById('themeToggle');
  if (!btn) return;
  btn.addEventListener('click', function () {
    var html = document.documentElement;
    var current = html.getAttribute('data-theme') || 'dark';
    var next = current === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', next);
    localStorage.setItem('theme', next);
  });
})();
