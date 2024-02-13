document.addEventListener('turbo:load', function() {
    searchUsersHandlers();
  });

function searchUsersHandlers() {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  document.getElementById('search-users-list-button').addEventListener('click', function() {
    var query = document.getElementById('search-users-list-query').value;

    fetch(`/search_users_list?query=${encodeURIComponent(query)}`, {
      method: 'GET',
      headers: {
        'Accept': 'text/html',
        'X-CSRF-Token': csrfToken
      }
    }).then(response => response.text())
      .then(data => {
        document.getElementById("user-list").innerHTML = data;
        assignEventHandlers();
        updateAvailableUserList();
      });
  });
}