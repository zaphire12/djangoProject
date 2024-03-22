async function loader () {
    const loaderFull = `
      <div id="loading-full">
        <div
          data-te-loading-icon-ref
          class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-current border-r-transparent motion-reduce:animate-[spin_1.5s_linear_infinite]"
          role="status"></div>
        <span data-te-loading-text-ref>Loading...</span>
      </div>
      `;
    const test2 = document.getElementById("full-screen-example");
      test2.insertAdjacentHTML("beforeend", loaderFull);

      const loadingFull = document.getElementById("loading-full");

      const loading = new te.LoadingManagement(loadingFull, {
        scroll: false,
        backdropID: "full-backdrop",
      });
      return loading;
};
console.log(te.LoadingManagement.getInstance(loader()));





