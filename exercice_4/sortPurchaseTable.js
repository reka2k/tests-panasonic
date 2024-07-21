function sortOrders(){    
    let order = document.getElementById('ordre').value;
    let dateDebut = document.getElementById('dateDebut').value;
    let dateFin = document.getElementById('dateFin').value;

    let tableBody = document.querySelector('tbody');
    let rows = Array.from(tableBody.querySelectorAll('tr'));


    function sortRows(rows){
        return rows.sort((a, b) => {
            let dateA = new Date(a.querySelector('#confirmed_delay').textContent);
            let dateB = new Date(b.querySelector('#confirmed_delay').textContent);

            if(dateA < dateB){
                return -1;
            } else if(dateA > dateB){
                return 1;
            } else {
                return 0;
            }
        });
    }


    if(order === 'desc'){
        tableBody.innerHTML = '';
        rows = sortRows(rows).reverse();
        rows.forEach(row => tableBody.appendChild(row));
    } 
    if(order === 'asc'){
        tableBody.innerHTML = '';
        rows = sortRows(rows);
        rows.forEach(row => tableBody.appendChild(row));
    }

    if (dateDebut){
        dateDebut = new Date(dateDebut);
        if (dateFin === ''){
            dateFin = new Date().setFullYear(dateDebut.getFullYear() + 1);
        } else {
            dateFin = new Date(dateFin);
        }
        filteredRows = rows.filter(row => {
            let date = new Date(row.querySelector('#confirmed_delay').textContent);
            return date >= dateDebut && date <= dateFin;
        });
        rows.forEach(row => {
            if(filteredRows.includes(row)){
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

}

