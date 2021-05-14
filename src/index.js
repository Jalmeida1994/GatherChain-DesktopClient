const electron = require("electron");
const {app, BrowserWindow} = electron;
const fs = require('fs');

// Handle creating/removing shortcuts on Windows when installing/uninstalling.
if (require('electron-squirrel-startup')) { // eslint-disable-line global-require
  app.quit();
}


const createWindow = () => {
  getIfLogged();
};

const getIfLogged = () => {
  if ((fs.existsSync(`${__dirname}/../.number.env`)) && (fs.existsSync(`${__dirname}/../.token.env`))) {
    // File exists in path
    console.log(`${__dirname}/../` + " logged")
    isLogged();
  } else {
    console.log(`${__dirname}/../` + " not logged")
    // File doesn't exist in path
    isNotLogged();
  }
}

const isNotLogged = () => {
  console.log('👋 Not logged');
  console.log(`${__dirname}`);

  const mainWindow = new BrowserWindow({
    height: 700,
    width: 900,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true
    }
  });

  mainWindow.loadURL(`file://${__dirname}/../src/notlogged.html`);

  mainWindow.webContents.openDevTools();
}

const isLogged = () => {
  console.log('👋 Logged');
  console.log(`${__dirname}`);

  const mainWindow = new BrowserWindow({
    height: 700,
    width: 900,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true
    }
  });

  mainWindow.loadURL(`file://${__dirname}/../src/waitingauth.html`);

  mainWindow.webContents.openDevTools();
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow);

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and import them here.
