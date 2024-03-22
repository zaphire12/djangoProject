const btnfull = document.getElementById("btn-full-screen");
let gridApi;
async function assembleFilters () {
    const first_date = document.getElementById('first_date').value
    const second_date = document.getElementById('second_date').value
    localStorage.setItem(pathname + "." + first_date_l.id, first_date.toString())
    localStorage.setItem(pathname + "." + second_date_l.id, second_date.toString())
    const selectorValue =  (d)  => {
        var elm = document.getElementById(d);
        var values = [];
        if (elm.multiple) {
          for (var i = 0; i < elm.options.length; i ++) {
            if (elm.options[i].selected)
               values.push(elm.options[i].value);
          }
        } else
          values.push(elm.value);
        return values
    }
    return {
        first_date: first_date,
        second_date: second_date,
        lpu: selectorValue('lpu'),
        dep: selectorValue('dep'),
        emp: selectorValue('emp'),
        doc_type: selectorValue('doc_type')
    }
}
async function data_set_dashboard () {
    const data = await assembleFilters()
    const response = await fetch('/api/v1/_data_set_dashboard/', {method: 'POST', body: JSON.stringify(data)})
    if (!response.ok) {
        throw new Error(`Ошибка HTTP: ${response.status}`);
    }
    return await response.json();
}
async function data_set_designer () {
    const data = await assembleFilters()
    const response = await fetch('/api/v1/_data_set_designer/', {method: 'POST', body: JSON.stringify(data)})
    if (!response.ok) {
        throw new Error(`Ошибка HTTP: ${response.status}`);
    }
    return await response.json();
}
async function lpu_lists () {
    const response = await fetch('/api/v1/_lpu_list/', {method: 'POST'})
    if (!response.ok) {
        throw new Error(`Ошибка HTTP: ${response.status}`);
    }
    return await response.json();
}
async function dep_select() {
    const dep_select = document.getElementById("dep");
    dep_select.innerHTML = ``
    const response = await fetch('/api/v1/_lpu_dep_list/', {method: 'POST'})
    await response.json().then( async (data) => {
        data.data.forEach((element) => {
            dep_select.insertAdjacentHTML("beforeend", `
                <option value="${element.lpu_dep}">${element.lpu_dep}</option>
            `)
        })
    });
}
async function doc_type_list() {
    const doc_type_select = document.getElementById("doc_type");
    doc_type_select.innerHTML = ``
    const response = await fetch('/api/v1/_doc_type_list/', {method: 'POST'})
    response.json().then( async (data) => {
        data.data.forEach((element) => {
            doc_type_select.insertAdjacentHTML('beforeend', `
                <option value="${element.doc_type}">${element.doc_type}</option>
            `)
        })
    });
}
async function emp_list() {
    const emp_select = document.getElementById("emp");
    emp_select.innerHTML = ``
    const response = await fetch('/api/v1/_emp_list/', {method: 'POST'})
    await response.json().then( async (data) => {
        data.data.forEach((element) => {
            emp_select.insertAdjacentHTML("beforeend", `
                <option value="${element.employer}">${element.employer}</option>
            `)
        })
    });
}
async function designer(){
    const myGridElement = document.querySelector('#myGrid');
    myGridElement.innerHTML = ``
    const first_date = document.getElementById('first_date').value
    const second_date = document.getElementById('second_date').value
    if (first_date.length !== 10 || second_date.length !== 10) {
        return 0
    }
    const data = await data_set_designer()
    const lpu_list = await lpu_lists()
    const d = data.data.map((row) => {
        const lpu_id = row.l;
        const foundObject = lpu_list.data.find(obj => obj.id === lpu_id);
        return {
            ...row,
            fullname: foundObject.fullname
        }
    })
    const gridOptions = {
        suppressAggFuncInHeader: true,
        groupDefaultExpanded: 1,
        sideBar: true,
        pivotPanelShow: 'always',
        defaultColDef: {
            flex: 1,
            autoHeaderHeight: true,
            wrapHeaderText: true,
            enablePivot: true,
            enableRowGroup: true,

        },
        rowGroupPanelShow: 'always',
        rowData: d,
        columnDefs: [
            {
                field: 'fullname',
                headerName: 'ЛПУ',
                filter: true,
                enableRowGroup: true,
                tooltipValueGetter: (params) => params.value,
            },
            {
                field: 'd',
                filter: true,
                headerName: 'Подразделение',
                tooltipValueGetter: (params) => params.value,
            },
            {
                field: 'e',
                filter: true,
                headerName: 'Врач',
            },
            {
                field: 't',
                headerName: 'Тип документа',
                filter: true,
                tooltipValueGetter: (params) => params.value,
                minWidth: 300,
            },
            {
                field: "z",
                headerName: 'Всего оказано услуг',
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
                field: "x",
                headerName: 'Всего сформировано СЭМД',
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
                field: "c",
                headerName: 'Всего зарегистрировано СЭМД',
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
                field: "dp",
                headerName: 'Дата',
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                width: 100,
            },
        ]
    }
    gridApi = agGrid.createGrid(myGridElement, gridOptions);

}
async function dashboard() {
    const myGridElement = document.querySelector('#myGrid');
    myGridElement.innerHTML = ``
    const first_date = document.getElementById('first_date').value
    const second_date = document.getElementById('second_date').value
    if (first_date.length !== 10 || second_date.length !== 10) {
        return 0
    }
    const data = await data_set_dashboard()
    const lpu_list = await lpu_lists()
    const d = data.data.map((row) => {
        const lpu_id = row.l;
        const foundObject = lpu_list.data.find(obj => obj.id === lpu_id);
        return {
            ...row,
            fullname: foundObject.fullname
        }
    })
    const gridOptions = {
        rowGroupPanelShow: 'always',
        suppressAggFuncInHeader: true,
        groupDefaultExpanded: 1,
        sideBar: {
            toolPanels: [
              {
                id: 'filters',
                labelDefault: 'Фильтр',
                labelKey: 'filters',
                iconKey: 'filter',
                toolPanel: 'agFiltersToolPanel',
              },
            ],
          },
        autoGroupColumnDef: {
            headerName: 'Медицинская организация ── Подразделение ── Врач',
            minWidth: 550,
            tooltipValueGetter: (params) => params.value,
            sort: 'asc'

        },
        defaultColDef: {
            flex: 1,
            autoHeaderHeight: true,
            wrapHeaderText: true,
            resizable: false,
        },
        rowData: d,
        columnDefs: [
            {
                field: 'fullname',
                headerName: 'ЛПУ',
                suppressMovable: true,
                hide: true,
                rowGroup: true,
                enableRowGroup: true,
                tooltipValueGetter: (params) => params.value,
            },
            {
                field: 'd',
                headerName: 'Подразделение',
                suppressMovable: true,
                hide: true,
                filter: true,
                rowGroup: true,
                enableRowGroup: true,
            },
            {
                field: 'e',
                headerName: 'Врач',
                suppressMovable: true,
                filter: true,
                hide: true,
                rowGroup: true,
                enableRowGroup: true,
            },
            {
                field: 't',
                headerName: 'Тип документа',
                filter: true,
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                floatingFilter: true,
                tooltipValueGetter: (params) => params.value,
                minWidth: 300,
                aggFunc: 'sum'
            },
            {
                field: "z",
                headerName: 'Всего оказано услуг',
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
                field: "x",
                headerName: 'Всего сформировано СЭМД',
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
                field: "c",
                headerName: 'Всего зарегистрировано СЭМД',
                suppressMovable: true,
                suppressHeaderMenuButton: true,
                aggFunc: 'sum',
                width: 100,
            },
            {
              headerName: 'Процент сформированных СЭМД',
              headerTooltip: 'Процент сформированных документов за выбранный период',
              colId: 'goldSilverRatio',
              aggFunc: ratioAggFuncFormed,
              valueGetter: ratioValueGetterFormed,
              valueFormatter: ratioFormatter,
              width: 100,
            },
            {
              headerName: 'Процент зарегистрированных СЭМД',
              headerTooltip: 'Процент сформированных документов за выбранный период',
              colId: 'goldSilverRatio1',
              aggFunc: ratioAggFuncReg,
              valueGetter: ratioValueGetterReg,
              valueFormatter: ratioFormatter,
              width: 100,
            },
        ]
    }
    gridApi = agGrid.createGrid(myGridElement, gridOptions);
}
function expandAll() {
  gridApi.expandAll();
}
function collapseAll() {
  gridApi.collapseAll();
}
function expandOrganization() {
  gridApi.forEachNode((node) => {
    if (node.level === 0) {
      gridApi.setRowNodeExpanded(node, true);
    }
  });
}
function onFilterTextBoxChanged() {
    gridApi.setGridOption(
        'quickFilterText',
        document.getElementById('filter-text-box1').value
    );
}
