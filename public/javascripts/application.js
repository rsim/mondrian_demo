$(function() {

  $("form").bind("ajax:error", function(e, xhr, status, error) {
    alert("Error "+xhr.status+"\n"+
          "There was error when performing your request."
    );
    return false;
  });

});

Highcharts.setOptions({
  credits: {
    enabled: false
  },
  chart: {
    style: {
      zIndex: 1
    }
  },
  title: {
    text: null,
    style: {
      fontFamily: 'arial, helvetica, tahoma, sans-serif',
      fontSize: '14px',
      fontWeight: 'bold',
      color: '#000000',
    }
  },
  plotOptions: {
    pie: {
      dataLabels: {
        style: {
          fontFamily: 'arial, helvetica, tahoma, sans-serif',
          fontSize: '14px',
          fontWeight: 'bold',
          color: '#000000'
        }
      }
    },
    series: {
      animation: {
        duration: 100
      }
    }
  },
  xAxis: {
    title: {
      text: null
    },
    labels: {
      style: {
        fontFamily: 'arial, helvetica, tahoma, sans-serif',
        fontSize: '14px',
        fontWeight: 'bold',
        color: '#000000'
      }
    }
  },
  yAxis: {
    min: 0,
    title: {
      text: null
    }
  },
  legend: {
    layout: 'horizontal',
    align: 'center',
    verticalAlign: 'top',
    itemStyle: {
      fontFamily: 'arial, helvetica, tahoma, sans-serif',
      fontSize: '14px',
      fontWeight: 'bold',
      color: '#000000'
    },
    itemHoverStyle: {
      fontFamily: 'arial, helvetica, tahoma, sans-serif',
      fontSize: '14px',
      fontWeight: 'bold',
      color: '#000000'
    }
  }
});
