<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/Jalmeida1994/GatherChain-DesktopClient">
    <img src="images/Logo-02.png" alt="Logo" width="120">
  </a>

  <h3 align="center">GatherChain Desktop App</h3>

  <p align="center">
    Desktop client made for the GatherChain solution.
    <br />
    <a href="https://github.com/Jalmeida1994/GatherChain-DesktopClient/blob/master/README.md"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Jalmeida1994/GatherChain-DesktopClient/issues">Report Bug</a>
    ·
    <a href="https://github.com/Jalmeida1994/GatherChain-DesktopClient/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Home Screen][home-screenshot]](images/HomeScreen.png)


GatherChain is the solution created for my Master Thesis: __Tracing Responsibility in Evolution of Model's Life Cycle in Collaborative Projects in Education__.
In the paper, it is proposed a blockchain-based solution for version control of engineering artefacts.  The goal is to facilitate collaboration in a multi-user area,like the education field, and track changes in a trusted and secure manner. This solution is based on using the Hyperledger Fabric Network to govern and regulate file version control functions among students and teachers.
This repository is a part of the larger GatherChain solution.

The other GatherChain projects are:
* __GatherChain ARM Template__: https://github.com/Jalmeida1994/GatherChain-ARM-Template
* __GatherChain Web Server__: https://github.com/Jalmeida1994/GatherChain-Web-Server
* __GatherChain Blockchain Server__: https://github.com/Jalmeida1994/GatherChain-BlockChain-Server
* __GatherChain Admin Commands__: https://github.com/Jalmeida1994/GatherChain-AdminCommands

This repository serves as the desktop interface for the solution. Made to be used by the users of the system.

### Built With

* [Electron](https://www.electronjs.org)
* [Shell Scripts](https://www.shellscript.sh)
    * [GNU Bash](https://www.gnu.org/software/bash/)


<!-- GETTING STARTED -->
## Getting Started

In this section it'll be shown how to get started with this solution. After the resources are deployed in the cloud using [GatherChain ARM Template](https://github.com/Jalmeida1994/GatherChain-ARM-Template) and you can follow the distribution steps presented here.
### Prerequisites

* [GatherChain resources deployed in the cloud](https://github.com/Jalmeida1994/GatherChain-ARM-Template)
* [macOS](https://www.apple.com/macos)
* [NPM](https://www.npmjs.com/)

### Installation

1. Clone the repo
   ```
   git clone https://github.com/Jalmeida1994/GatherChain-DesktopClient.git
   ```
2. Change the [weburl.env](https://github.com/Jalmeida1994/GatherChain-DesktopClient/blob/master/.weburl.env) file with the URL of the WebApp instantiated during the GatherChain ARM Template phase.
    ```
    export WEB_URL=https://NameOfTheApp.azurewebsites.net
    ```
    The domain `azurewebsites` is only used if the GatherChain Template was deployed in Azure and if no custom domain was configured in the webapp.
    
3. Change the [admin.env](https://github.com/Jalmeida1994/GatherChain-DesktopClient/blob/master/.admin.env) file with the GitHub account of the administrator of the class.
    ```
    export ADMIN=GITHUB_USERNAME
    ```    
5. Install npm modules from `package.json` and create the distributable app.
   ```
   cd /path/to/GatherChain-DesktopClient
   npm install
   npm run make
   ```
6. Distribute to the class the macOS application created during the previous step in the path `/path/to/GatherChain-DesktopClient/out/gatherchainx64/gatherchain.app`
   

<!-- USAGE EXAMPLES -->
## Usage

When the blockchain is initialized using [GatherChain Admin Commands](https://github.com/Jalmeida1994/GatherChain-AdminCommands), the users can use the application as their version-control GUI.

<!-- USAGE EXAMPLES -->
### Register Student

To register in the app the users need to have a GitHub account. The application asks for the student number and then it redirects to the [GitHub's device activation screen](https://github.com/login/device). The code to be pasted is copied to the clipboard automatically. If it's not you can go the app screen and copy the code from it.

[![Welcome Screen][welcome-screenshot]](images/WelcomeScreen.png)

### Choose Project Folder

After the student number and GitHub account are registered in the solution, the user is prompt to choose the folder location to host the project.

### Create Group

If the folder is does not have a project yet, then, the user is prompt to create a group. The group elements must already be registered in the solution. The user inserts the other group element's numbers seperated by WHITESPACE (eg: 1937 1954).

[![Group Creation Screen][groupcreation-screenshot]](images/GroupCreationScreen.png)

### Home Screen

After the group is created the users can use the app as a normal version control interface. The users can check the commits, timestamps of said commits and respective authors, stored in the blockchain network.

[![Home Screen][home-screenshot]](images/HomeScreen.png)

* Users can push the new changes;
* Users can pull/download the most recent group changes;
* Users can undo to a certain past commit (The commits deleted are still stored in the blockchain network);
* Users can check the file changes in each commit with GitHub's incorporated `diff` screen. [Example](https://github.com/Jalmeida1994/GatherChain-DesktopClient/commit/7033909ba10dd4e76e653f845955ec56c2ee3392)

[![Actions][actions-screenshot]](images/Actions.png)


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/Jalmeida1994/GatherChain-DesktopClient/issues) for a list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

João Almeida - [@João Almeida](https://www.linkedin.com/in/jo%C3%A3o-almeida-525476125/) - jcfd.almeida@campus.fct.unl.pt

Project Link: [https://github.com/Jalmeida1994/GatherChain-DesktopClient](https://github.com/Jalmeida1994/GatherChain-DesktopClient)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [FCT-UNL](https://www.fct.unl.pt/)
* [Professor Vasco Amaral](https://docentes.fct.unl.pt/vma/)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Jalmeida1994/GatherChain-DesktopClient.svg?style=for-the-badge
[contributors-url]: https://github.com/Jalmeida1994/GatherChain-DesktopClient/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Jalmeida1994/GatherChain-DesktopClient.svg?style=for-the-badge
[forks-url]: https://github.com/Jalmeida1994/GatherChain-DesktopClient/network/members
[stars-shield]: https://img.shields.io/github/stars/Jalmeida1994/GatherChain-DesktopClient.svg?style=for-the-badge
[stars-url]: https://github.com/Jalmeida1994/GatherChain-DesktopClient/stargazers
[issues-shield]: https://img.shields.io/github/issues/Jalmeida1994/GatherChain-DesktopClient.svg?style=for-the-badge
[issues-url]: https://github.com/Jalmeida1994/GatherChain-DesktopClient/issues
[license-shield]: https://img.shields.io/github/license/Jalmeida1994/GatherChain-DesktopClient.svg?style=for-the-badge
[license-url]: https://github.com/Jalmeida1994/GatherChain-DesktopClient/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jo%C3%A3o-almeida-525476125/
[product-screenshot]: images/arm-template.png
