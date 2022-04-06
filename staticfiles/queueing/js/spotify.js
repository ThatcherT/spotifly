// send ajax to server and shuffle for IAmDJ
function shuffle() {
  $.ajax({
    url: "/ajax/shuffle/",
    data: {
      IAmDJ: IAmDJ,
      csrfmiddlewaretoken: window.CSRF_TOKEN,
    },
    type: "POST",
    dataType: "json",
    success: function (data) {
      // shuffle success message
      mainContent.innerHTML += `
            <div class="row">
                <div class="col-12">
                    <h2 style="color: green; font-size: 2em;>Shuffle Success</h2>
                </div>
            </div>

        `;
    },
    error: function (xhr, status, error) {
      // shuffle error message
      mainContent.innerHTML += `
            <div class="row">
                <div class="col-12">
                    <h2 style="color: red; font-size: 2em;>Shuffle Error</h2>
                </div>
            </div>
            `;
    },
  });
}

function followDJ() {
  // store dj in session
  const followingDJ = document.getElementById("follow-dj").value;
  $.ajax({
    url: "/ajax/follow-dj/",
    type: "POST",
    data: {
      csrfmiddlewaretoken: window.CSRF_TOKEN,
      followingDJ: followingDJ,
    },
    dataType: "json",
    success: function (data) {
      // update jQuery data
      console.log("success!");
      jQuery.data(document.body, "followingDJ", followingDJ);
      console.log("loading page");
      console.log(jQuery.data(document.body, "followingDJ"));
      loadPage();

      return true;
    },
    error: function (xhr, status, error) {
      alert(xhr.responseText);
      console.log(status, error);
      return false;
    },
  });
}
