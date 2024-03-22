function updateThemeIcon(theme) {
    const grid = document.getElementById('myGrid')
    if (grid) {
        updateGridTheme(theme)
    }
    const themeIcon = document.getElementById('themeIcon');
    if (themeIcon) {
        themeIcon.innerHTML = '';
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        svg.setAttribute('viewBox', '0 0 24 24');
        svg.setAttribute('fill', 'currentColor');
        svg.setAttribute('class', 'inline-block h-5 w-5');
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        if (theme === 'dark') {
            path.setAttribute('fill-rule', 'evenodd');
            path.setAttribute('d', 'M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69a.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162');
        } else {
            path.setAttribute('d', 'M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z');
        }
        svg.appendChild(path);
        themeIcon.appendChild(svg);
    }
};
function updateGridTheme (theme) {
    const grid = document.getElementById('myGrid')
    if (theme === "system") {
        grid.classList.remove('ag-theme-alpine-dark')
        grid.classList.add('ag-theme-alpine')
    } else if (theme === "dark") {
        grid.classList.remove('ag-theme-alpine')
        grid.classList.add('ag-theme-alpine-dark')
    } else {
        grid.classList.remove('ag-theme-alpine-dark')
        grid.classList.add('ag-theme-alpine')
    }
}

updateThemeIcon(localStorage.theme);
if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.documentElement.classList.add('dark');
} else {
    document.documentElement.classList.remove('dark');
};
function setDarkTheme() {
    document.documentElement.classList.add("dark");
    localStorage.theme = "dark";
};
function setLightTheme() {
    document.documentElement.classList.remove("dark");
    localStorage.theme = "light";
};
function onThemeSwitcherItemClick(event) {
    const theme = event.target.dataset.theme;
    if (theme === "system") {
        localStorage.removeItem("theme");
        setSystemTheme();
    } else if (theme === "dark") {
      updateThemeIcon('dark')
        setDarkTheme();
    } else {
        setLightTheme();
        updateThemeIcon('light')
    }
};
const themeSwitcherItems = document.querySelectorAll("#theme-switcher");
themeSwitcherItems.forEach((item) => {
  item.addEventListener("click", onThemeSwitcherItemClick);
});
class TotalValueRenderer {
  eGui;
  eButton;
  eValue;
  cellValue;
  eventListener;

  // gets called once before the renderer is used
  init(params) {
    // create the cell
    this.eGui = document.createElement('div');
    this.eGui.innerHTML = `
          <span>
              <span class="my-value"></span>
              <button class="btn-simple">Push For Total</button>
          </span>
       `;

    // get references to the elements we want
    this.eButton = this.eGui.querySelector('.btn-simple');
    this.eValue = this.eGui.querySelector('.my-value');

    // set value into cell
    this.cellValue = this.getValueToDisplay(params);
    this.eValue.textContent = this.cellValue;

    // add event listener to button
    this.eventListener = () => alert(`${this.cellValue} medals won!`);
    this.eButton.addEventListener('click', this.eventListener);
  }

  getGui() {
    return this.eGui;
  }

  // gets called whenever the cell refreshes
  refresh(params) {
    // set value into cell again
    this.cellValue = this.getValueToDisplay(params);
    this.eValue.textContent = this.cellValue;

    // return true to tell the grid we refreshed successfully
    return true;
  }

  // gets called when the cell is removed from the grid
  destroy() {
    // do cleanup, remove event listener from button
    if (this.eButton) {
      // check that the button element exists as destroy() can be called before getGui()
      this.eButton.removeEventListener('click', this.eventListener);
    }
  }

  getValueToDisplay(params) {
    return params.valueFormatted ? params.valueFormatted : params.value;
  }
}