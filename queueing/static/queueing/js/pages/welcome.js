/*
This file contains the html and document manipulation code that executes when a user is signing up: when they don't have DJ account in their local storage.
*/
var mainContent = document.getElementById("main-content");

function loadWelcomePage() {
    // a welcome message
    mainContent.innerHTML = `
        <div class="row">
            <div class="col-12">
                <p>
                    QSongs allows you to queue songs on your friends' devices. Or, become the
                    DJ, and enable others to queue songs on your device.
                </p>
            </div>
        </div>`;
    // when click get-started button, show the dj form
    document.getElementById("get-started").addEventListener("click", function () {
        mainContent.classList.add("dj-form");

        mainContent.innerHTML = djFormHeader;
        document.getElementById("get-started").style.display = "none";
        mainContent.classList.remove("main-text");
        mainContent.classList.add("form-head");
    });

    document.getElementById("get-started").style.display = "";
}

// the form to choose between following a dj or becoming one
var djFormHeader = `
    <div class="row">
        <div class="col-12">
            <p>
                The choice is yours.
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


// shows the form to follow a dj
function followDJButton() {
    mainContent.innerHTML =
        djFormHeader +
        `
            <div class="row">
                <div class="col-12">
                    <form id="follow-dj-form" onSubmit="return followDJ();">
                        <div class="form-group">
                            <label for="follow-dj">DJ Name</label>
                            <input type="text" class="form-control big-ole-form-input" id="follow-dj" required>
                        </div>
                        <button id="follow-dj-btn" class="btn btn-primary btn-lg form-submit">
                            Submit
                        </button>
                    </form>
                </div>
            </div>`;
}

// shows the form to become a dj
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
                djFormHeader + `
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
        error: function (xhr, status, error) {
            alert(xhr.responseText);
        },
    });
}
