$(document).ready(function(){
   
  
    /*****************************************************************/
    /***** Pikaday - SetInit *****/
    /*****************************************************************/
    var picker = new Pikaday(
    {
        field: document.getElementById('datepicker'),
        firstDay: 1,
        minDate: new Date('2000-01-01'),
        maxDate: new Date('2020-12-31'),
        format:'DD/MM/YYYY',
        yearRange:[2000,2020],
        i18n: {
            previousMonth : 'Anterior',
            nextMonth     : 'Pr\xf3ximo',
            months        : ['Janeiro','Fevereiro','Mar\xe7o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
            weekdays      : ['Domingo','Segunda','Ter\xe7a','Quarta','Quinta','Sexta','S\xe1bado'],
            weekdaysShort : ['Dom','Seg','Ter','Qua','Qui','Sex','S\xe1b']
        }
    }); //end Pikaday
    
        
    var picker = new Pikaday(
    {
        field: document.getElementById('datepicker2'),
        firstDay: 1,
        minDate: new Date('2000-01-01'),
        maxDate: new Date('2020-12-31'),
        format:'DD/MM/YYYY',
        yearRange:[2000,2020],
        i18n: {
            previousMonth : 'Anterior',
            nextMonth     : 'Pr\xf3ximo',
            months        : ['Janeiro','Fevereiro','Mar\xe7o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
            weekdays      : ['Domingo','Segunda','Ter\xe7a','Quarta','Quinta','Sexta','S\xe1bado'],
            weekdaysShort : ['Dom','Seg','Ter','Qua','Qui','Sex','S\xe1b']
        }
    }); //end Pikaday
    
}); // end Funções Diversas