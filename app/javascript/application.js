// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// import Rails from "@rails/ujs"
// Rails.start()

document.addEventListener('turbo:load', function() {
    var addMaterialLink = document.getElementById('addMaterialLink');
    var addMaterialModal = document.getElementById('addMaterialModal');

    addMaterialLink.addEventListener('click', function(event) {
      event.preventDefault();
      addMaterialModal.style.display = 'block';
    });

    // Close the modal when clicking outside of it
    window.addEventListener('click', function(event) {
      if (event.target == addMaterialModal) {
        addMaterialModal.style.display = 'none';
      }
    });

    // Handle material deletion
    var deleteMaterialLinks = document.querySelectorAll('.delete-material-link');
    deleteMaterialLinks.forEach(function(link) {
      link.addEventListener('click', function(event) {
        event.preventDefault();
        var materialId = link.getAttribute('data-material-id');
        var disciplineId = link.getAttribute('data-discipline-id');
        deleteMaterial(materialId, disciplineId);
      });
    });

    function deleteMaterial(materialId, disciplineId) {
      // Получение CSRF-токена
      var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      // Выполнение асинхронного запроса для удаления материала
      var xhr = new XMLHttpRequest();
      xhr.open('DELETE', `/disciplines/${disciplineId}/detach_material/${materialId}`, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', csrfToken);
      xhr.onload = function() {
        if (xhr.status === 200 || xhr.status === 204) {
          console.log('Материал успешно удален');
          // Перезагрузка страницы после успешного удаления
          location.reload();
        } else {
          console.error('Ошибка при удалении материала');
        }
      };
      xhr.send();
    }
  });