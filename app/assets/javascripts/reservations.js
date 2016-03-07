// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var guestCounter = 0;

function formatGuest(guestArray) {
  var guest = {};
  guestArray.map(function(data) {
    guest[data.name] = data.value;
  });
  
  return guest;
}

function removeGuest(guest) {
  var input = guest.find('input[type=hidden]')[0];
  input.value = JSON.stringify({_destroy: true});
  guest.hide();
  if ($('#guest-list tr:visible').length <= 0) {
    $('#guest-container').hide();
  }
}

function addGuest() {
  var guestData = formatGuest($('#guestModal form').serializeArray());
  var row = document.createElement('tr');
  
  var nameCell = document.createElement('td');
  var name = document.createTextNode(guestData.first_name + ' ' + guestData.last_name);
  nameCell.appendChild(name);
  
  var dataCell = document.createElement('td');
  var data = document.createElement('input');
  data.type = 'hidden';
  data.name = 'reservation[guests_attributes][' + guestCounter + ']';
  data.value = JSON.stringify(guestData);
  dataCell.appendChild(data);
  
  var controlCell = document.createElement('td');
  var control = document.createElement('span');
  control.setAttribute('class', 'glyphicon glyphicon-remove remove-guest');
  controlCell.appendChild(control);
  
  row.appendChild(nameCell);
  row.appendChild(dataCell);
  row.appendChild(controlCell);
  
  var list = document.getElementById('guest-list');
  list.appendChild(row);
  
  guestCounter += 1;
  $('#guest-container').show();
  $('#guestModal').modal('toggle');
}

$(document).ready(function() {
  guestCounter = $('#guest-list tr').length;
  
  $('#add-guest').click(function(e) {
    e.preventDefault();
    addGuest();
  });
  
  $('#guest-list').on('click', '.remove-guest', function(e) {
    e.preventDefault();
    var guest = $(e.currentTarget).closest('tr');
    removeGuest(guest);
  });
  
  $("#guestModal").on("hidden.bs.modal", function(){
    $(this).find('form input').val('');
  });
});
