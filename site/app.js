const fluxaConfig = {
  repoOwner: "NAGCODE-Dev",
  repoName: "Fluxa",
  webAppUrl: "/app/",
};

const releaseApiUrl = `https://api.github.com/repos/${fluxaConfig.repoOwner}/${fluxaConfig.repoName}/releases`;

const latestVersion = document.getElementById("latest-version");
const latestDate = document.getElementById("latest-date");
const latestSummary = document.getElementById("latest-summary");
const latestDownload = document.getElementById("latest-download");
const heroDownload = document.getElementById("hero-download");
const downloadVersion = document.getElementById("download-version");
const downloadNotes = document.getElementById("download-notes");
const downloadButton = document.getElementById("download-button");
const releaseList = document.getElementById("release-list");
const webButton = document.getElementById("web-button");
const heroWeb = document.getElementById("hero-web");

function formatDate(value) {
  try {
    return new Intl.DateTimeFormat("pt-BR", {
      day: "2-digit",
      month: "long",
      year: "numeric",
    }).format(new Date(value));
  } catch {
    return value;
  }
}

function summarize(body) {
  if (!body || !body.trim()) {
    return "Sem changelog informado nesta release.";
  }

  const cleaned = body
    .replace(/[#>*`-]/g, " ")
    .replace(/\s+/g, " ")
    .trim();

  return cleaned.length > 180 ? `${cleaned.slice(0, 177)}...` : cleaned;
}

function findApkAsset(release) {
  return (release.assets || []).find((asset) =>
    asset.name.toLowerCase().endsWith(".apk"),
  );
}

function setDownloadLink(button, href, label) {
  button.href = href;
  button.textContent = label;
  button.classList.remove("disabled");
}

function renderLatest(release) {
  const apk = findApkAsset(release);
  const summary = summarize(release.body);

  latestVersion.textContent = release.name || release.tag_name;
  latestDate.textContent = `Publicado em ${formatDate(release.published_at)}`;
  latestSummary.textContent = summary;

  downloadVersion.textContent = release.name || release.tag_name;
  downloadNotes.textContent = summary;

  if (apk) {
    setDownloadLink(latestDownload, apk.browser_download_url, `Baixar ${apk.name}`);
    setDownloadLink(heroDownload, apk.browser_download_url, "Baixar APK");
    setDownloadLink(downloadButton, apk.browser_download_url, "Baixar versão atual");
  } else {
    latestDownload.textContent = "APK não encontrado";
    downloadButton.textContent = "APK não encontrado";
  }
}

function renderHistory(releases) {
  if (!releases.length) {
    return;
  }

  releaseList.innerHTML = "";

  releases.forEach((release) => {
    const apk = findApkAsset(release);
    const row = document.createElement("article");
    row.className = "surface release-row";

    const content = document.createElement("div");
    const tag = document.createElement("div");
    tag.className = "release-tag";
    tag.innerHTML = `<span>${release.name || release.tag_name}</span><span class="release-date">${formatDate(release.published_at)}</span>`;

    const notes = document.createElement("p");
    notes.className = "muted";
    notes.textContent = summarize(release.body);

    content.appendChild(tag);
    content.appendChild(notes);

    const action = document.createElement("a");
    action.className = `btn ${apk ? "btn-primary" : "btn-secondary disabled"}`;
    action.href = apk ? apk.browser_download_url : "#";
    action.textContent = apk ? "Baixar APK" : "Sem APK";

    row.appendChild(content);
    row.appendChild(action);
    releaseList.appendChild(row);
  });
}

async function loadReleases() {
  try {
    const response = await fetch(releaseApiUrl, {
      headers: {
        Accept: "application/vnd.github+json",
      },
    });

    if (!response.ok) {
      throw new Error(`GitHub respondeu com status ${response.status}`);
    }

    const releases = await response.json();
    const published = releases.filter((item) => !item.draft);

    if (!published.length) {
      return;
    }

    renderLatest(published[0]);
    renderHistory(published.slice(0, 8));
  } catch (error) {
    latestVersion.textContent = "Release indisponível";
    latestDate.textContent = "Não foi possível consultar o GitHub agora.";
    latestSummary.textContent =
      "O site está pronto, mas a leitura automática da release falhou nesta tentativa.";
    console.error(error);
  }
}

function configureWebCallToAction() {
  if (!fluxaConfig.webAppUrl) {
    return;
  }

  setDownloadLink(webButton, fluxaConfig.webAppUrl, "Abrir Fluxa Web");
  setDownloadLink(heroWeb, fluxaConfig.webAppUrl, "Abrir Fluxa Web");
}

configureWebCallToAction();
loadReleases();
