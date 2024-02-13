document.addEventListener('turbo:load', function() {
  assignEventHandlers();
  searchHandlers();
});

function updateAvailableUserList() {
  const selectedUsersLabel = document.getElementById('selected-users-label');
  const selectedUserIds = new Set(
      Array.from(document.querySelectorAll('#selected-users input[type="hidden"]'))
          .map(input => input.value)
  );

  document.querySelectorAll('.user').forEach(userDiv => {
      const userId = userDiv.querySelector('.add-user-btn').dataset.userId;
      if (selectedUserIds.has(userId)) {
          userDiv.style.display = 'none'; // Скрываем пользователя
      } else {
          userDiv.style.display = ''; // Показываем пользователя
      }
  });

  // Показываем или скрываем надпись в зависимости от наличия выбранных пользователей
  if (selectedUserIds.size > 0) {
      selectedUsersLabel.style.display = ''; // Показываем надпись
  } else {
      selectedUsersLabel.style.display = 'none'; // Скрываем надпись
  }
}

function assignEventHandlers() {
  document.querySelectorAll('.add-user-btn').forEach(function(button) {
    button.addEventListener('click', function() {
      var userId = this.dataset.userId;
      var userDiv = this.closest('.user');
      var userName = userDiv.querySelector('td').textContent; // Извлекаем имя пользователя

      var selectedUsersDiv = document.getElementById('selected-users');
      var selectedUserDiv = document.createElement('div');
      selectedUserDiv.classList.add("d-flex", "align-items-center", "mb-2");

      // Создаем span для имени пользователя
      var userNameSpan = document.createElement('span');
      userNameSpan.classList.add("badge", "bg-success", "me-2");
      userNameSpan.textContent = userName;

      // Создаем span для крестика
      var removeIcon = document.createElement('span');
      removeIcon.classList.add("ms-2", "remove-icon");
      removeIcon.innerHTML = '&times;'; // HTML-сущность крестика
      removeIcon.style.cursor = 'pointer';
      removeIcon.addEventListener('click', function() {
          selectedUserDiv.remove(); // Удаление пользователя из списка
          updateAvailableUserList();
      });

      // Добавляем скрытый input
      var hiddenInput = document.createElement('input');
      hiddenInput.type = 'hidden';
      hiddenInput.name = 'user_ids[]';
      hiddenInput.value = userId;

      // Собираем элементы вместе
      userNameSpan.appendChild(removeIcon);
      selectedUserDiv.appendChild(userNameSpan);
      selectedUserDiv.appendChild(hiddenInput);
      selectedUsersDiv.appendChild(selectedUserDiv);

      updateAvailableUserList();
    });
  });
}

function searchHandlers() {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  document.getElementById('search-button').addEventListener('click', function() {
    var query = document.getElementById('search-query').value;

    fetch(`/search_users?query=${encodeURIComponent(query)}`, {
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