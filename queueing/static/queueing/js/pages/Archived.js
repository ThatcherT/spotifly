// Archived because it was redundant with the loadDJsPage() function
// shows the form to follow a dj
async function followDJButton() {
  const djObj = await getDJs();
  mainContent.innerHTML =
    djFormHeader +
    `<div class="column">
                  <div class="col-12">
                  <select id="dj-select" class="selectpicker" data-style="btn-lg big-ole-btn" data-size="10" data-live-search="true">
                          <option selected disabled>Select a DJ</option>
                          ${djObj.djs
                            .map((dj) => `<option value="${dj}">${dj}</option>`)
                            .join("")}
                      </select>
                  </div>
              </div>
              <div class="row">
                  <div class="col-12">
                      <button id="follow-dj-btn" class="btn btn-primary btn-lg form-submit big-ole-btn" onClick="followDJ()">
                          Submit
                      </button>
                  </div>
              </div>
              <div class="row">
                  <div class="col-12">
                      <p id="follow-dj-error" class="error-message"></p>
                  </div>
              </div>`;
  $("#dj-select").selectpicker().selectpicker("refresh");
}

// Archived because its functionality is being incorporated into the loadProfilePage() function
// NOT NEEDED ANYMORE BUT KEEPING FOR REFERENCE
function loadWelcomePage() {
  // a welcome message
  mainContent.innerHTML = `
            <div class="row">
                <div class="col-12">
                    <p>
                        QSongs lets you to queue songs on your friends' devices. Or, become the
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
