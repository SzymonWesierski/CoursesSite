// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "hamburger"];

  connect() {
    this.menu = this.menuTarget;
    this.hamburger = this.hamburgerTarget;
    
    // Dodajemy nasłuchiwanie na kliknięcia
    this.handleClickOutside = this.closeMenu.bind(this);
    this.handleResize = this.handleResize.bind(this);

    document.addEventListener('click', this.handleClickOutside);
    window.addEventListener('resize', this.handleResize);
  }

  disconnect() {
    // Usuwamy nasłuchiwane zdarzenia, gdy kontroler jest usuwany
    document.removeEventListener('click', this.handleClickOutside);
    window.removeEventListener('resize', this.handleResize);
  }

  // Funkcja do przełączania widoczności menu
  toggleMenu(event) {
    event.stopPropagation(); // Zapobiega zamknięciu menu przy kliknięciu w hamburger
    this.menu.classList.toggle('active');
  }

  // Funkcja do zamykania menu
  closeMenu(event) {
    // Jeśli kliknięcie miało miejsce poza menu i hamburgerem, zamykamy menu
    if (!this.menu.contains(event.target) && !this.hamburger.contains(event.target)) {
      this.menu.classList.remove('active');
    }
  }

  // Funkcja do ukrywania menu przy rozszerzeniu okna
  handleResize() {
    if (window.innerWidth > 768) {
      this.menu.classList.remove('active');
    }
  }
}
