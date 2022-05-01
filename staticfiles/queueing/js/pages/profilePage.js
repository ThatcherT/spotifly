// Profile Page
function loadProfilePage() {
    updateActiveIcon(document.getElementById("profile-icon"));
    if (IAmDJ) {
      mainContent.innerHTML = `
              <div class="row">
                  <div class="col-12">
                      <h1>Profile</h1>
                  </div>
              </div>
              <div class="row">
                  <div class="col-12">
                      <p>
                          This is your profile.
                      </p>
                      <p>
                          You are DJ ${IAmDJ}
                      </p>
                      <button class="btn btn-primary big-ole-btn" onclick="shuffle()">Shuffle</button>
                  </div>
              </div>
              <div class="row">
                  <div class="col-12">
                      <p id="shuffle-message" style="padding-top: 10%; display: none;">
                          Shuffle Message
                      </p>
                  </div>
              </div>`;
    } else {
      $.ajax({
        url: "/spotify/connect-link/",
        type: "GET",
        dataType: "json",
        data: {
          csrfmiddlewaretoken: window.CSRF_TOKEN,
        },
        success: function (data) {
          mainContent.innerHTML = `
              <div class="row">
                  <div class="col-12">
                      <h1>Connect with spotify to become a DJ</h1>
                  </div>
              </div>
              <div class="row">
                  <div class="col-12">
                      <a href="${data.url}">
                          <button id="connect-with-spotify" class="btn btn-primary btn-lg">
                              Connect with Spotify
                          </button>
                      </a>
                  </div>
              </div>`;
        },
        error: function (xhr, status, error) {
          alert(xhr.responseText);
        },
      });
    }
  }