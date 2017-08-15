 $(document).ready(function(){
    $('#map').jMapping({
    map_config: {
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.DEFAULT
      },
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoom: 7
    }
  });

  });