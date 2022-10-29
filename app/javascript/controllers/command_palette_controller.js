import { Controller } from "@hotwired/stimulus"
import "ninja-keys"

// Connects to data-controller="command-palette"
export default class extends Controller {
  connect() {
    this.element.data = [
      {
        id: "accueil",
        title: "Accueil",
        hotkey: "ctrl + A",
        icon: `<svg width="14" height="14" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 21H7a4 4 0 0 1-4-4v-6.292a4 4 0 0 1 1.927-3.421l5-3.03a4 4 0 0 1 4.146 0l5 3.03A4 4 0 0 1 21 10.707V17a4 4 0 0 1-4 4h-2m-6 0v-4a3 3 0 0 1 3-3v0a3 3 0 0 1 3 3v4m-6 0h6"/></svg>&nbsp;`,
        handler: () => {
          Turbo.visit("/");
        },
      },
      {
        id: "questions",
        title: "Questions",
        hotkey: "ctrl + Q",
        icon: `<svg width="14" height="14" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 10h8m-8 4h4m0 8c5.523 0 10-4.477 10-10S17.523 2 12 2S2 6.477 2 12c0 1.821.487 3.53 1.338 5L2.5 21.5l4.5-.838A9.955 9.955 0 0 0 12 22Z"/></svg>&nbsp;`,
        handler: () => {
          Turbo.visit("/questions");
        },
      },
      {
        id: "Theme",
        title: "Change theme...",
        icon: `<svg width="14" height="14" viewBox="0 0 24 24"><g fill="none" stroke-width="1.5"><path stroke="currentColor" stroke-linecap="round" d="M12 21H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v7"/><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" d="M2 7h20M5 5.01l.01-.011M8 5.01l.01-.011M11 5.01l.01-.011"/><path stroke="currentColor" d="m18 14l1.225 1.044l1.603.128l.128 1.603L22 18l-1.044 1.225l-.128 1.603l-1.603.128L18 22l-1.225-1.044l-1.603-.128l-.128-1.603L14 18l1.044-1.225l.128-1.603l1.603-.128L18 14Z"/><path fill="currentColor" d="M16.775 20.956L18 22v-8l-1.225 1.044l-1.603.128l-.128 1.603L14 18l1.044 1.225l.128 1.603l1.603.128Z"/></g></svg>&nbsp;`,
        children: ["Light Theme", "Dark Theme", "System Theme"],
        hotkey: "ctrl + T",
        handler: () => {
          // open menu if closed. Because you can open directly that menu from it's hotkey
          ninja.open({ parent: "Theme" });
          // if menu opened that prevent it from closing on select that action, no need if you don't have child actions
          return { keepOpen: true };
        },
      },
      {
        id: "Light Theme",
        title: "Change theme to Light",
        icon: `<svg width="14" height="14" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 18a6 6 0 1 0 0-12a6 6 0 0 0 0 12Zm10-6h1M12 2V1m0 22v-1m8-2l-1-1m1-15l-1 1M4 20l1-1M4 4l1 1m-4 7h1"/></svg>&nbsp;`,
        parent: "Theme",
        handler: () => {
          // simple handler
          document.documentElement.classList.remove("dark");
        },
      },
      {
        id: "Dark Theme",
        title: "Change theme to Dark",
        icon: `<svg width="14" height="14" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 11.507a9.493 9.493 0 0 0 18 4.219c-8.507 0-12.726-4.22-12.726-12.726A9.494 9.494 0 0 0 3 11.507Z"/></svg>&nbsp;`,
        parent: "Theme",
        handler: () => {
          // simple handler
          document.documentElement.classList.add("dark");
        },
      },
    ];
  }
}
