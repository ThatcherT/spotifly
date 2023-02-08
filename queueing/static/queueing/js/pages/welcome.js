/*
This file contains the html and document manipulation code that executes when a user is signing up: when they don't have DJ account in their local storage.
*/
var mainContent = document.getElementById("main-content");

// the form to choose between following a dj or becoming one
var djFormHeader = `
    <div class="row">
        <div class="col-12">
            <p>
                The choice is yours...
            </p>
        </div>
    </div>
    <div class="row">
        <div class="col-6">
            <button id="become-dj" class="btn btn-primary btn-lg" onClick="becomeDJButton()">
                Become a DJ
            </button>
        </div>
        <div class="col-6">
            <button id="follow-dj" class="btn btn-primary btn-lg" onClick="followDJButton()">
                Follow a DJ
            </button>
        </div>
    </div>`;

// Refactoring this to handle the whole welcome flow for login and directing users to DJ page
function becomeDJButton() {
  $.ajax({
    url: "/spotify/connect-link/",
    type: "GET",
    data: {
      csrfmiddlewaretoken: window.CSRF_TOKEN,
    },
    dataType: "json",
    success: function (data) {
      mainContent.innerHTML =
        djFormHeader +
        `
                    <div class="row">
                        <div class="col-12">
                            <a href="${data.url}">
                                <button id="connect-with-spotify" class="btn btn-primary btn-lg big-ole-btn" style="background-color: green;">
                                    Connect with Spotify
                                </button>
                            </a>
                        </div>
                    </div>`;
    },
  });
}


