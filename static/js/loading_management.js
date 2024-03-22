const loaderFull = `
  <div id="loading-full">
    <div
      data-te-loading-icon-ref
      class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-current border-r-transparent motion-reduce:animate-[spin_1.5s_linear_infinite]"
      role="status"></div>
    <span data-te-loading-text-ref>Загрузка...</span>
  </div>
  `
const test2 = document.getElementById("full-screen-example");
test2.insertAdjacentHTML("beforeend", loaderFull);
const loadingFull = document.getElementById("loading-full");

async function main() {
    const loading = new te.LoadingManagement(loadingFull, {
        scroll: false,
        backdropID: "full-backdrop",
    });
    const promises = [await emp_list(), await dep_select(), await doc_type_list(), await dashboard()];
    await Promise.all(promises);
    loading.dispose();
    document.body.classList.remove("overflow-hidden");
}
async function loader_dashboard(){
    let loading = te.LoadingManagement.getOrCreateInstance(loadingFull)
    const promises = [await dashboard()];
    await Promise.all(promises);
    loading.dispose();
}
async function loader_designer() {
    let loading = te.LoadingManagement.getOrCreateInstance(loadingFull)
    const promises = [ await dep_select(), await doc_type_list(), await designer()];
    await Promise.all(promises);
    loading.dispose();
}
async function loader_designer_button() {
    let loading = te.LoadingManagement.getOrCreateInstance(loadingFull)
    const promises = [await designer()];
    await Promise.all(promises);
    loading.dispose();
}
async function loader (func=[]) {
    let loading = te.LoadingManagement.getOrCreateInstance(loadingFull)
    await Promise.all(func);
    loading.dispose();
}