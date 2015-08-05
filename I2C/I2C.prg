


<!DOCTYPE html>
<html lang="en" class=" is-copy-enabled">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta name="viewport" content="width=1020">
    
    
    <title>SBA-Library/I2C.prg at Branch_master_0 · mriscoc/SBA-Library</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub">
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub">
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png">
    <meta property="fb:app_id" content="1401488693436528">

      <meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="mriscoc/SBA-Library" name="twitter:title" /><meta content="SBA-Library - SBA IP Cores  http://sba.accesus.com" name="twitter:description" /><meta content="https://avatars3.githubusercontent.com/u/2745567?v=3&amp;s=400" name="twitter:image:src" />
      <meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="https://avatars3.githubusercontent.com/u/2745567?v=3&amp;s=400" property="og:image" /><meta content="mriscoc/SBA-Library" property="og:title" /><meta content="https://github.com/mriscoc/SBA-Library" property="og:url" /><meta content="SBA-Library - SBA IP Cores  http://sba.accesus.com" property="og:description" />
      <meta name="browser-stats-url" content="https://api.github.com/_private/browser/stats">
    <meta name="browser-errors-url" content="https://api.github.com/_private/browser/errors">
    <link rel="assets" href="https://assets-cdn.github.com/">
    <link rel="web-socket" href="wss://live.github.com/_sockets/MTI2MTk5MjA6YWUwYzIyMDg5M2Q5YWRmMWUzNjg5Y2JkNGRlODRkMDA6ZmZjOGU5NGQ1ZWMxYjA2N2M4NWU2ZTUyYTg0ZWUwYjZhZTZlYzAyZDgzNTY3YWIxMGUzMDU1OWFmZTU5ODliOQ==--1902bdc41aa599a8641eb8d87f3298c44f9b4688">
    <meta name="pjax-timeout" content="1000">
    <link rel="sudo-modal" href="/sessions/sudo_modal">

    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="selected-link" value="repo_source" data-pjax-transient>

        <meta name="google-analytics" content="UA-3769691-2">

    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="github" name="octolytics-app-id" /><meta content="B5429D9A:0A7A:72DC359:55C26A6C" name="octolytics-dimension-request_id" /><meta content="12619920" name="octolytics-actor-id" /><meta content="jvegam" name="octolytics-actor-login" /><meta content="46fc023e19e4f8b2c712b1353d8be95c088643a080b63cae51faa19894b0db18" name="octolytics-actor-hash" />
    
    <meta content="Rails, view, blob#show" data-pjax-transient="true" name="analytics-event" />
    <meta class="js-ga-set" name="dimension1" content="Logged In">
      <meta class="js-ga-set" name="dimension4" content="Current repo nav">
    <meta name="is-dotcom" content="true">
        <meta name="hostname" content="github.com">
    <meta name="user-login" content="jvegam">

      <link rel="icon" sizes="any" mask href="https://assets-cdn.github.com/pinned-octocat.svg">
      <meta name="theme-color" content="#4078c0">
      <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">

    <!-- </textarea> --><!-- '"` --><meta content="authenticity_token" name="csrf-param" />
<meta content="g8yLqYDVLjRoLASFtwsUzTqUt6b2tZQJJr1F6ejq8DKoOQ/TBKZg3K3ENe2/HfW/5Cvd9BvQkQGy6kKY33NPCQ==" name="csrf-token" />
    

    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/github/index-e85c4df2f00f610f7d403b70cb6ff08a89f810737918e84973d175e3c3e31f50.css" media="all" rel="stylesheet" />
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/github2/index-bf44996cc962b9028644d3383c46968cdf015fdf3ea77ded8998258e917f2c3f.css" media="all" rel="stylesheet" />
    
    


    <meta http-equiv="x-pjax-version" content="33efb2eb7993dd801cd157c7dd40cf9f">

      
  <meta name="description" content="SBA-Library - SBA IP Cores  http://sba.accesus.com">
  <meta name="go-import" content="github.com/mriscoc/SBA-Library git https://github.com/mriscoc/SBA-Library.git">

  <meta content="2745567" name="octolytics-dimension-user_id" /><meta content="mriscoc" name="octolytics-dimension-user_login" /><meta content="6585221" name="octolytics-dimension-repository_id" /><meta content="mriscoc/SBA-Library" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="6585221" name="octolytics-dimension-repository_network_root_id" /><meta content="mriscoc/SBA-Library" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/mriscoc/SBA-Library/commits/Branch_master_0.atom" rel="alternate" title="Recent Commits to SBA-Library:Branch_master_0" type="application/atom+xml">

  </head>


  <body class="logged_in  env-production windows vis-public page-blob">
    <a href="#start-of-content" tabindex="1" class="accessibility-aid js-skip-to-content">Skip to content</a>
    <div class="wrapper">
      
      
      



        <div class="header header-logged-in true" role="banner">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/" data-hotkey="g d" aria-label="Homepage" data-ga-click="Header, go to dashboard, icon:logo">
  <span class="mega-octicon octicon-mark-github"></span>
</a>


      <div class="site-search repo-scope js-site-search" role="search">
          <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/search" class="js-site-search-form" data-global-search-url="/search" data-repo-search-url="/mriscoc/SBA-Library/search" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
  <label class="js-chromeless-input-container form-control">
    <div class="scope-badge">This repository</div>
    <input type="text"
      class="js-site-search-focus js-site-search-field is-clearable chromeless-input"
      data-hotkey="s"
      name="q"
      placeholder="Search"
      aria-label="Search this repository"
      data-global-scope-placeholder="Search GitHub"
      data-repo-scope-placeholder="Search"
      tabindex="1"
      autocapitalize="off">
  </label>
</form>
      </div>

      <ul class="header-nav left" role="navigation">
        <li class="header-nav-item">
          <a href="/pulls" class="js-selected-navigation-item header-nav-link" data-ga-click="Header, click, Nav menu - item:pulls context:user" data-hotkey="g p" data-selected-links="/pulls /pulls/assigned /pulls/mentioned /pulls">
            Pull requests
</a>        </li>
        <li class="header-nav-item">
          <a href="/issues" class="js-selected-navigation-item header-nav-link" data-ga-click="Header, click, Nav menu - item:issues context:user" data-hotkey="g i" data-selected-links="/issues /issues/assigned /issues/mentioned /issues">
            Issues
</a>        </li>
          <li class="header-nav-item">
            <a class="header-nav-link" href="https://gist.github.com/" data-ga-click="Header, go to gist, text:gist">Gist</a>
          </li>
      </ul>

    
<ul class="header-nav user-nav right" id="user-links">
  <li class="header-nav-item">
      <span class="js-socket-channel js-updatable-content"
        data-channel="notification-changed:jvegam"
        data-url="/notifications/header">
      <a href="/notifications" aria-label="You have no unread notifications" class="header-nav-link notification-indicator tooltipped tooltipped-s" data-ga-click="Header, go to notifications, icon:read" data-hotkey="g n">
          <span class="mail-status all-read"></span>
          <span class="octicon octicon-inbox"></span>
</a>  </span>

  </li>

  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link tooltipped tooltipped-s js-menu-target" href="/new"
       aria-label="Create new…"
       data-ga-click="Header, create new, icon:add">
      <span class="octicon octicon-plus left"></span>
      <span class="dropdown-caret"></span>
    </a>

    <div class="dropdown-menu-content js-menu-content">
      <ul class="dropdown-menu dropdown-menu-sw">
        
<a class="dropdown-item" href="/new" data-ga-click="Header, create new repository">
  New repository
</a>


  <a class="dropdown-item" href="/organizations/new" data-ga-click="Header, create new organization">
    New organization
  </a>



  <div class="dropdown-divider"></div>
  <div class="dropdown-header">
    <span title="mriscoc/SBA-Library">This repository</span>
  </div>
    <a class="dropdown-item" href="/mriscoc/SBA-Library/issues/new" data-ga-click="Header, create new issue">
      New issue
    </a>

      </ul>
    </div>
  </li>

  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link name tooltipped tooltipped-s js-menu-target" href="/jvegam"
       aria-label="View profile and more"
       data-ga-click="Header, show menu, icon:avatar">
      <img alt="@jvegam" class="avatar" height="20" src="https://avatars2.githubusercontent.com/u/12619920?v=3&amp;s=40" width="20" />
      <span class="dropdown-caret"></span>
    </a>

    <div class="dropdown-menu-content js-menu-content">
      <div class="dropdown-menu dropdown-menu-sw">
        <div class="dropdown-header header-nav-current-user css-truncate">
          Signed in as <strong class="css-truncate-target">jvegam</strong>
        </div>
        <div class="dropdown-divider"></div>

        <a class="dropdown-item" href="/jvegam" data-ga-click="Header, go to profile, text:your profile">
          Your profile
        </a>
        <a class="dropdown-item" href="/stars" data-ga-click="Header, go to starred repos, text:your stars">
          Your stars
        </a>
        <a class="dropdown-item" href="/explore" data-ga-click="Header, go to explore, text:explore">
          Explore
        </a>
        <a class="dropdown-item" href="https://help.github.com" data-ga-click="Header, go to help, text:help">
          Help
        </a>
        <div class="dropdown-divider"></div>

        <a class="dropdown-item" href="/settings/profile" data-ga-click="Header, go to settings, icon:settings">
          Settings
        </a>

        <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/logout" class="logout-form" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="/z8emUdIVPQlPiHS/579a+EmbSLrNesmfPgQTEZpPdG36tMvC8is8kIZHzOvWLdBQA0t3eD8XiXZZwQxUaiZCA==" /></div>
          <button class="dropdown-item dropdown-signout" data-ga-click="Header, sign out, icon:logout">
            Sign out
          </button>
</form>      </div>
    </div>
  </li>
</ul>


    
  </div>
</div>

        

        


      <div id="start-of-content" class="accessibility-aid"></div>
          <div class="site" itemscope itemtype="http://schema.org/WebPage">
    <div id="js-flash-container">
      
    </div>
    <div class="pagehead repohead instapaper_ignore readability-menu ">
      <div class="container">

        <div class="clearfix">
          
<ul class="pagehead-actions">

  <li>
      <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/notifications/subscribe" class="js-social-container" data-autosubmit="true" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="Q+KBECvG68fndXbQkyoRK85TVAckB26bPSvyZapyWNT9K2J333f1oeeRpHeDSWJ81vInhE1741LNCbqezWJIFA==" /></div>    <input id="repository_id" name="repository_id" type="hidden" value="6585221" />

      <div class="select-menu js-menu-container js-select-menu">
        <a href="/mriscoc/SBA-Library/subscription"
          class="btn btn-sm btn-with-count select-menu-button js-menu-target" role="button" tabindex="0" aria-haspopup="true"
          data-ga-click="Repository, click Watch settings, action:blob#show">
          <span class="js-select-button">
            <span class="octicon octicon-eye"></span>
            Unwatch
          </span>
        </a>
        <a class="social-count js-social-count" href="/mriscoc/SBA-Library/watchers">
          1
        </a>

        <div class="select-menu-modal-holder">
          <div class="select-menu-modal subscription-menu-modal js-menu-content" aria-hidden="true">
            <div class="select-menu-header">
              <span class="select-menu-title">Notifications</span>
              <span class="octicon octicon-x js-menu-close" role="button" aria-label="Close"></span>
            </div>

            <div class="select-menu-list js-navigation-container" role="menu">

              <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input id="do_included" name="do" type="radio" value="included" />
                  <span class="select-menu-item-heading">Not watching</span>
                  <span class="description">Be notified when participating or @mentioned.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-eye"></span>
                    Watch
                  </span>
                </div>
              </div>

              <div class="select-menu-item js-navigation-item selected" role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                  <span class="select-menu-item-heading">Watching</span>
                  <span class="description">Be notified of all conversations.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-eye"></span>
                    Unwatch
                  </span>
                </div>
              </div>

              <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input id="do_ignore" name="do" type="radio" value="ignore" />
                  <span class="select-menu-item-heading">Ignoring</span>
                  <span class="description">Never be notified.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-mute"></span>
                    Stop ignoring
                  </span>
                </div>
              </div>

            </div>

          </div>
        </div>
      </div>
</form>
  </li>

  <li>
    
  <div class="js-toggler-container js-social-container starring-container ">

    <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/unstar" class="js-toggler-form starred js-unstar-button" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="oymbr1bko1jVFW3H21l7bGzbTBwyACAT2b0NjYgvZXkaX8LEryEUZrvbiDrlirv0kxtQCDmAZOsXFghPGBqrCQ==" /></div>
      <button
        class="btn btn-sm btn-with-count js-toggler-target"
        aria-label="Unstar this repository" title="Unstar mriscoc/SBA-Library"
        data-ga-click="Repository, click unstar button, action:blob#show; text:Unstar">
        <span class="octicon octicon-star"></span>
        Unstar
      </button>
        <a class="social-count js-social-count" href="/mriscoc/SBA-Library/stargazers">
          1
        </a>
</form>
    <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/star" class="js-toggler-form unstarred js-star-button" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="5DESfbW4T6ZDIy2yi6KiEsuoOHFbcfeepjI8q5Qwb3pyb3ak7fEyFLIHS1DK8EL6CZRvpRtQKh+O9+aIt0OzOQ==" /></div>
      <button
        class="btn btn-sm btn-with-count js-toggler-target"
        aria-label="Star this repository" title="Star mriscoc/SBA-Library"
        data-ga-click="Repository, click star button, action:blob#show; text:Star">
        <span class="octicon octicon-star"></span>
        Star
      </button>
        <a class="social-count js-social-count" href="/mriscoc/SBA-Library/stargazers">
          1
        </a>
</form>  </div>

  </li>

        <li>
          <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/fork" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="7z5dZaGXq91k+mvwjao2x3lXWWzstCHssIISFxa7jYtGWqhkr161+YBXQshCv6wDiV3g2BZWz/j/0z2MJKuk0w==" /></div>
            <button
                type="submit"
                class="btn btn-sm btn-with-count"
                data-ga-click="Repository, show fork modal, action:blob#show; text:Fork"
                title="Fork your own copy of mriscoc/SBA-Library to your account"
                aria-label="Fork your own copy of mriscoc/SBA-Library to your account">
              <span class="octicon octicon-repo-forked"></span>
              Fork
            </button>
            <a href="/mriscoc/SBA-Library/network" class="social-count">0</a>
</form>        </li>

</ul>

          <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public ">
            <span class="mega-octicon octicon-repo"></span>
            <span class="author"><a href="/mriscoc" class="url fn" itemprop="url" rel="author"><span itemprop="title">mriscoc</span></a></span><!--
         --><span class="path-divider">/</span><!--
         --><strong><a href="/mriscoc/SBA-Library" data-pjax="#js-repo-pjax-container">SBA-Library</a></strong>

            <span class="page-context-loader">
              <img alt="" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
            </span>

          </h1>
        </div>

      </div>
    </div>

      <div class="container">
        <div class="repository-with-sidebar repo-container new-discussion-timeline ">
          <div class="repository-sidebar clearfix">
              

<nav class="sunken-menu repo-nav js-repo-nav js-sidenav-container-pjax js-octicon-loaders"
     role="navigation"
     data-pjax="#js-repo-pjax-container"
     data-issue-count-url="/mriscoc/SBA-Library/issues/counts">
  <ul class="sunken-menu-group">
    <li class="tooltipped tooltipped-w" aria-label="Code">
      <a href="/mriscoc/SBA-Library/tree/Branch_master_0" aria-label="Code" aria-selected="true" class="js-selected-navigation-item selected sunken-menu-item" data-hotkey="g c" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches /mriscoc/SBA-Library/tree/Branch_master_0">
        <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>    </li>

      <li class="tooltipped tooltipped-w" aria-label="Issues">
        <a href="/mriscoc/SBA-Library/issues" aria-label="Issues" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g i" data-selected-links="repo_issues repo_labels repo_milestones /mriscoc/SBA-Library/issues">
          <span class="octicon octicon-issue-opened"></span> <span class="full-word">Issues</span>
          <span class="js-issue-replace-counter"></span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

    <li class="tooltipped tooltipped-w" aria-label="Pull requests">
      <a href="/mriscoc/SBA-Library/pulls" aria-label="Pull requests" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g p" data-selected-links="repo_pulls /mriscoc/SBA-Library/pulls">
          <span class="octicon octicon-git-pull-request"></span> <span class="full-word">Pull requests</span>
          <span class="js-pull-replace-counter"></span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>    </li>

      <li class="tooltipped tooltipped-w" aria-label="Wiki">
        <a href="/mriscoc/SBA-Library/wiki" aria-label="Wiki" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g w" data-selected-links="repo_wiki /mriscoc/SBA-Library/wiki">
          <span class="octicon octicon-book"></span> <span class="full-word">Wiki</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>
  </ul>
  <div class="sunken-menu-separator"></div>
  <ul class="sunken-menu-group">

    <li class="tooltipped tooltipped-w" aria-label="Pulse">
      <a href="/mriscoc/SBA-Library/pulse" aria-label="Pulse" class="js-selected-navigation-item sunken-menu-item" data-selected-links="pulse /mriscoc/SBA-Library/pulse">
        <span class="octicon octicon-pulse"></span> <span class="full-word">Pulse</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>    </li>

    <li class="tooltipped tooltipped-w" aria-label="Graphs">
      <a href="/mriscoc/SBA-Library/graphs" aria-label="Graphs" class="js-selected-navigation-item sunken-menu-item" data-selected-links="repo_graphs repo_contributors /mriscoc/SBA-Library/graphs">
        <span class="octicon octicon-graph"></span> <span class="full-word">Graphs</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32.gif" width="16" />
</a>    </li>
  </ul>


</nav>

                <div class="only-with-full-nav">
                    
<div class="js-clone-url clone-url open"
  data-protocol-type="http">
  <h3><span class="text-emphasized">HTTPS</span> clone URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="https://github.com/mriscoc/SBA-Library.git" readonly="readonly" aria-label="HTTPS clone URL">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard btn btn-sm zeroclipboard-button tooltipped tooltipped-s" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  
<div class="js-clone-url clone-url "
  data-protocol-type="ssh">
  <h3><span class="text-emphasized">SSH</span> clone URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="git@github.com:mriscoc/SBA-Library.git" readonly="readonly" aria-label="SSH clone URL">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard btn btn-sm zeroclipboard-button tooltipped tooltipped-s" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  
<div class="js-clone-url clone-url "
  data-protocol-type="subversion">
  <h3><span class="text-emphasized">Subversion</span> checkout URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="https://github.com/mriscoc/SBA-Library" readonly="readonly" aria-label="Subversion checkout URL">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard btn btn-sm zeroclipboard-button tooltipped tooltipped-s" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>



  <div class="clone-options">You can clone with
    <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/users/set_protocol?protocol_selector=http&amp;protocol_type=push" class="inline-form js-clone-selector-form is-enabled" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="ZDcXrwfp80M+FmpjKaNf1wwv/43LKupyc8qNJ3xPIaCOkzxOroDUdzVQQ+kJ3ad37C2f/lGF4RhrBKq6ypT/sg==" /></div><button class="btn-link js-clone-selector" data-protocol="http" type="submit">HTTPS</button></form>, <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/users/set_protocol?protocol_selector=ssh&amp;protocol_type=push" class="inline-form js-clone-selector-form is-enabled" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="pmITncrPdf8BB3TcEKy7RnA5Et7RK0uQlO4gNXsXsiyQOT+Rvqm+pErzvdxmcNiGE809LeL9zlGqJXvl64hHpg==" /></div><button class="btn-link js-clone-selector" data-protocol="ssh" type="submit">SSH</button></form>, or <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/users/set_protocol?protocol_selector=subversion&amp;protocol_type=push" class="inline-form js-clone-selector-form is-enabled" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="l0A7yPU8NYiKXbkZTLjmLQXsM9DQY6CVzZG6aJ0zOMkQeG8snc9RrgsxPhMlIGcIkN9exbyH7qQe5w5b79V6XQ==" /></div><button class="btn-link js-clone-selector" data-protocol="subversion" type="submit">Subversion</button></form>.
    <a href="https://help.github.com/articles/which-remote-url-should-i-use" class="help tooltipped tooltipped-n" aria-label="Get help on which URL is right for you.">
      <span class="octicon octicon-question"></span>
    </a>
  </div>
    <a href="github-windows://openRepo/https://github.com/mriscoc/SBA-Library" class="btn btn-sm sidebar-button" title="Save mriscoc/SBA-Library to your computer and use it in GitHub Desktop." aria-label="Save mriscoc/SBA-Library to your computer and use it in GitHub Desktop.">
      <span class="octicon octicon-device-desktop"></span>
      Clone in Desktop
    </a>

                  <a href="/mriscoc/SBA-Library/archive/Branch_master_0.zip"
                     class="btn btn-sm sidebar-button"
                     aria-label="Download the contents of mriscoc/SBA-Library as a zip file"
                     title="Download the contents of mriscoc/SBA-Library as a zip file"
                     rel="nofollow">
                    <span class="octicon octicon-cloud-download"></span>
                    Download ZIP
                  </a>
                </div>
          </div>
          <div id="js-repo-pjax-container" class="repository-content context-loader-container" data-pjax-container>

            

<a href="/mriscoc/SBA-Library/blob/6d7f0f73cafb7fd0fc19dfd5ae8d0c1703d1fe57/I2C/I2C.prg" class="hidden js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:63c5d85e20dd23187f6c675c41235381 -->

  <div class="file-navigation js-zeroclipboard-container">
    
<div class="select-menu js-menu-container js-select-menu left">
  <span class="btn btn-sm select-menu-button js-menu-target css-truncate" data-hotkey="w"
    data-ref="Branch_master_0"
    title="Branch_master_0"
    role="button" aria-label="Switch branches or tags" tabindex="0" aria-haspopup="true">
    <i>Branch:</i>
    <span class="js-select-button css-truncate-target">Branch_master_0</span>
  </span>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax aria-hidden="true">

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <span class="select-menu-title">Switch branches/tags</span>
        <span class="octicon octicon-x js-menu-close" role="button" aria-label="Close"></span>
      </div>

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Find or create a branch…" id="context-commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Find or create a branch…">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" data-filter-placeholder="Find or create a branch…" class="js-select-menu-tab" role="tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" data-filter-placeholder="Find a tag…" class="js-select-menu-tab" role="tab">Tags</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches" role="menu">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <a class="select-menu-item js-navigation-item js-navigation-open selected"
               href="/mriscoc/SBA-Library/blob/Branch_master_0/I2C/I2C.prg"
               data-name="Branch_master_0"
               data-skip-pjax="true"
               rel="nofollow">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <span class="select-menu-item-text css-truncate-target" title="Branch_master_0">
                Branch_master_0
              </span>
            </a>
            <a class="select-menu-item js-navigation-item js-navigation-open "
               href="/mriscoc/SBA-Library/blob/SBA_Branch_Juan/I2C/I2C.prg"
               data-name="SBA_Branch_Juan"
               data-skip-pjax="true"
               rel="nofollow">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <span class="select-menu-item-text css-truncate-target" title="SBA_Branch_Juan">
                SBA_Branch_Juan
              </span>
            </a>
            <a class="select-menu-item js-navigation-item js-navigation-open "
               href="/mriscoc/SBA-Library/blob/master/I2C/I2C.prg"
               data-name="master"
               data-skip-pjax="true"
               rel="nofollow">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <span class="select-menu-item-text css-truncate-target" title="master">
                master
              </span>
            </a>
        </div>

          <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/branches" class="js-create-branch select-menu-item select-menu-new-item-form js-navigation-item js-new-item-form" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="M6xuvC52oJZyKgESNyJhcfIg/FKQFcNrkCqtyUR0wDa6ChXJ2sxbWfmpm4YkM83eJc7QEhlAaEg9hbg/gxIKjA==" /></div>
            <span class="octicon octicon-git-branch select-menu-item-icon"></span>
            <div class="select-menu-item-text">
              <span class="select-menu-item-heading">Create branch: <span class="js-new-item-name"></span></span>
              <span class="description">from ‘Branch_master_0’</span>
            </div>
            <input type="hidden" name="name" id="name" class="js-new-item-value">
            <input type="hidden" name="branch" id="branch" value="Branch_master_0">
            <input type="hidden" name="path" id="path" value="I2C/I2C.prg">
</form>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div>

    </div>
  </div>
</div>

    <div class="btn-group right">
      <a href="/mriscoc/SBA-Library/find/Branch_master_0"
            class="js-show-file-finder btn btn-sm empty-icon tooltipped tooltipped-nw"
            data-pjax
            data-hotkey="t"
            aria-label="Quickly jump between files">
        <span class="octicon octicon-list-unordered"></span>
      </a>
      <button aria-label="Copy file path to clipboard" class="js-zeroclipboard btn btn-sm zeroclipboard-button tooltipped tooltipped-s" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </div>

    <div class="breadcrumb js-zeroclipboard-target">
      <span class="repo-root js-repo-root"><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mriscoc/SBA-Library/tree/Branch_master_0" class="" data-branch="Branch_master_0" data-pjax="true" itemscope="url"><span itemprop="title">SBA-Library</span></a></span></span><span class="separator">/</span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/mriscoc/SBA-Library/tree/Branch_master_0/I2C" class="" data-branch="Branch_master_0" data-pjax="true" itemscope="url"><span itemprop="title">I2C</span></a></span><span class="separator">/</span><strong class="final-path">I2C.prg</strong>
    </div>
  </div>

<include-fragment class="commit commit-loader file-history-tease" src="/mriscoc/SBA-Library/contributors/Branch_master_0/I2C/I2C.prg">
  <div class="file-history-tease-header">
    Fetching contributors&hellip;
  </div>

  <div class="participation">
    <p class="loader-loading"><img alt="" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32-EAF2F5.gif" width="16" /></p>
    <p class="loader-error">Cannot retrieve contributors at this time</p>
  </div>
</include-fragment>
<div class="file">
  <div class="file-header">
    <div class="file-actions">

      <div class="btn-group">
        <a href="/mriscoc/SBA-Library/raw/Branch_master_0/I2C/I2C.prg" class="btn btn-sm " id="raw-url">Raw</a>
          <a href="/mriscoc/SBA-Library/blame/Branch_master_0/I2C/I2C.prg" class="btn btn-sm js-update-url-with-hash">Blame</a>
        <a href="/mriscoc/SBA-Library/commits/Branch_master_0/I2C/I2C.prg" class="btn btn-sm " rel="nofollow">History</a>
      </div>

        <a class="octicon-btn tooltipped tooltipped-nw"
           href="github-windows://openRepo/https://github.com/mriscoc/SBA-Library?branch=Branch_master_0&amp;filepath=I2C%2FI2C.prg"
           aria-label="Open this file in GitHub for Windows"
           data-ga-click="Repository, open with desktop, type:windows">
            <span class="octicon octicon-device-desktop"></span>
        </a>

            <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/edit/Branch_master_0/I2C/I2C.prg" class="inline-form" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="i3XxaFh+Rp7gm3OIxUvskYSMnoUumxlROrGkSk2OS6GN/84ae7kqwOuSUkf+gbVUgZIE+WJBbOufSna4eGKMig==" /></div>
              <button class="octicon-btn tooltipped tooltipped-n" type="submit" aria-label="Edit this file" data-hotkey="e" data-disable-with>
                <span class="octicon octicon-pencil"></span>
              </button>
</form>
          <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/mriscoc/SBA-Library/delete/Branch_master_0/I2C/I2C.prg" class="inline-form" data-form-nonce="068b50287d6f35d656dd320f19905ca20ea93e96" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="Gr68E5dLUSNh+34lW50to/SzGo16SKNb2XzhYyjxnFF2c8olKUr/GurBCzOV6rKZZId4h+OUglRxEhpmwFCTog==" /></div>
            <button class="octicon-btn octicon-btn-danger tooltipped tooltipped-n" type="submit" aria-label="Delete this file" data-disable-with>
              <span class="octicon octicon-trashcan"></span>
            </button>
</form>    </div>

    <div class="file-info">
        208 lines (187 sloc)
        <span class="file-info-divider"></span>
      9.016 kB
    </div>
  </div>
  

  <div class="blob-wrapper data type-xbase">
      <table class="highlight tab-size js-file-line-container" data-tab-size="8">
      <tr>
        <td id="L1" class="blob-num js-line-number" data-line-number="1"></td>
        <td id="LC1" class="blob-code blob-code-inner js-file-line">-- /SBA: Program Details -------------------------------------------------------</td>
      </tr>
      <tr>
        <td id="L2" class="blob-num js-line-number" data-line-number="2"></td>
        <td id="LC2" class="blob-code blob-code-inner js-file-line">--</td>
      </tr>
      <tr>
        <td id="L3" class="blob-num js-line-number" data-line-number="3"></td>
        <td id="LC3" class="blob-code blob-code-inner js-file-line">-- Program: I2C Demo</td>
      </tr>
      <tr>
        <td id="L4" class="blob-num js-line-number" data-line-number="4"></td>
        <td id="LC4" class="blob-code blob-code-inner js-file-line">-- Version: <span class="pl-c1">1.0</span></td>
      </tr>
      <tr>
        <td id="L5" class="blob-num js-line-number" data-line-number="5"></td>
        <td id="LC5" class="blob-code blob-code-inner js-file-line">-- Date: <span class="pl-c1">20150604</span></td>
      </tr>
      <tr>
        <td id="L6" class="blob-num js-line-number" data-line-number="6"></td>
        <td id="LC6" class="blob-code blob-code-inner js-file-line">-- Author: Juan S. Vega Martinez</td>
      </tr>
      <tr>
        <td id="L7" class="blob-num js-line-number" data-line-number="7"></td>
        <td id="LC7" class="blob-code blob-code-inner js-file-line">-- Description: Snippet for I2C demo SBA Project</td>
      </tr>
      <tr>
        <td id="L8" class="blob-num js-line-number" data-line-number="8"></td>
        <td id="LC8" class="blob-code blob-code-inner js-file-line">--</td>
      </tr>
      <tr>
        <td id="L9" class="blob-num js-line-number" data-line-number="9"></td>
        <td id="LC9" class="blob-code blob-code-inner js-file-line">-- /SBA: End -------------------------------------------------------------------</td>
      </tr>
      <tr>
        <td id="L10" class="blob-num js-line-number" data-line-number="10"></td>
        <td id="LC10" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L11" class="blob-num js-line-number" data-line-number="11"></td>
        <td id="LC11" class="blob-code blob-code-inner js-file-line">-- /SBA: User Registers and Constants ------------------------------------------</td>
      </tr>
      <tr>
        <td id="L12" class="blob-num js-line-number" data-line-number="12"></td>
        <td id="LC12" class="blob-code blob-code-inner js-file-line">   constant I2C_TXSTA   : integer<span class="pl-k">:=</span><span class="pl-c1">15</span>;				        --Tx Ready</td>
      </tr>
      <tr>
        <td id="L13" class="blob-num js-line-number" data-line-number="13"></td>
        <td id="LC13" class="blob-code blob-code-inner js-file-line">   constant I2C_RXSTA   : integer<span class="pl-k">:=</span><span class="pl-c1">14</span>;				        --Rx Ready</td>
      </tr>
      <tr>
        <td id="L14" class="blob-num js-line-number" data-line-number="14"></td>
        <td id="LC14" class="blob-code blob-code-inner js-file-line">   constant I2C_ReadMEMORY   : <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>)<span class="pl-k">:=</span>x<span class="pl-s">&quot;08&quot;</span>; --Enable Read Data from internal memory</td>
      </tr>
      <tr>
        <td id="L15" class="blob-num js-line-number" data-line-number="15"></td>
        <td id="LC15" class="blob-code blob-code-inner js-file-line">   variable I2C_DEVICE_ADR   : <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);     	--I2C Address Device</td>
      </tr>
      <tr>
        <td id="L16" class="blob-num js-line-number" data-line-number="16"></td>
        <td id="LC16" class="blob-code blob-code-inner js-file-line">   variable I2C_DAT          : <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);     	--Data to Write or Read</td>
      </tr>
      <tr>
        <td id="L17" class="blob-num js-line-number" data-line-number="17"></td>
        <td id="LC17" class="blob-code blob-code-inner js-file-line">   variable I2C_ADR_REG      : <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);     	--Initial address register to Write or Read </td>
      </tr>
      <tr>
        <td id="L18" class="blob-num js-line-number" data-line-number="18"></td>
        <td id="LC18" class="blob-code blob-code-inner js-file-line">   variable I2C_NumberBytesRead: <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);		--Number of bytes to Write or Read</td>
      </tr>
      <tr>
        <td id="L19" class="blob-num js-line-number" data-line-number="19"></td>
        <td id="LC19" class="blob-code blob-code-inner js-file-line">   variable I2C_ADR_MEMORY   : <span class="pl-en">unsigned</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);        --Address Memory to Multiple Write </td>
      </tr>
      <tr>
        <td id="L20" class="blob-num js-line-number" data-line-number="20"></td>
        <td id="LC20" class="blob-code blob-code-inner js-file-line">   variable I2CFlg           : std_logic;	                --Flag status</td>
      </tr>
      <tr>
        <td id="L21" class="blob-num js-line-number" data-line-number="21"></td>
        <td id="LC21" class="blob-code blob-code-inner js-file-line">   variable reg1 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L22" class="blob-num js-line-number" data-line-number="22"></td>
        <td id="LC22" class="blob-code blob-code-inner js-file-line">   variable reg2 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L23" class="blob-num js-line-number" data-line-number="23"></td>
        <td id="LC23" class="blob-code blob-code-inner js-file-line">   variable reg3 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L24" class="blob-num js-line-number" data-line-number="24"></td>
        <td id="LC24" class="blob-code blob-code-inner js-file-line">   variable reg4 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L25" class="blob-num js-line-number" data-line-number="25"></td>
        <td id="LC25" class="blob-code blob-code-inner js-file-line">   variable reg5 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L26" class="blob-num js-line-number" data-line-number="26"></td>
        <td id="LC26" class="blob-code blob-code-inner js-file-line">   variable reg6 : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);       -- General purpose register</td>
      </tr>
      <tr>
        <td id="L27" class="blob-num js-line-number" data-line-number="27"></td>
        <td id="LC27" class="blob-code blob-code-inner js-file-line">   variable reg7 : <span class="pl-en">unsigned</span>(<span class="pl-c1">2</span> downto <span class="pl-c1">0</span>);        -- General purpose register</td>
      </tr>
      <tr>
        <td id="L28" class="blob-num js-line-number" data-line-number="28"></td>
        <td id="LC28" class="blob-code blob-code-inner js-file-line">   variable Dlytmp  : <span class="pl-en">unsigned</span>(<span class="pl-c1">15</span> downto <span class="pl-c1">0</span>);    -- Delay <span class="pl-c1">16</span> bit register</td>
      </tr>
      <tr>
        <td id="L29" class="blob-num js-line-number" data-line-number="29"></td>
        <td id="LC29" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L30" class="blob-num js-line-number" data-line-number="30"></td>
        <td id="LC30" class="blob-code blob-code-inner js-file-line">-- /SBA: End -------------------------------------------------------------------</td>
      </tr>
      <tr>
        <td id="L31" class="blob-num js-line-number" data-line-number="31"></td>
        <td id="LC31" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L32" class="blob-num js-line-number" data-line-number="32"></td>
        <td id="LC32" class="blob-code blob-code-inner js-file-line">-- /SBA: User Program ----------------------------------------------------------</td>
      </tr>
      <tr>
        <td id="L33" class="blob-num js-line-number" data-line-number="33"></td>
        <td id="LC33" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L34" class="blob-num js-line-number" data-line-number="34"></td>
        <td id="LC34" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAjump</span>(Init);</td>
      </tr>
      <tr>
        <td id="L35" class="blob-num js-line-number" data-line-number="35"></td>
        <td id="LC35" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L36" class="blob-num js-line-number" data-line-number="36"></td>
        <td id="LC36" class="blob-code blob-code-inner js-file-line">-------------------------------- RUTINES ---------------------------------------</td>
      </tr>
      <tr>
        <td id="L37" class="blob-num js-line-number" data-line-number="37"></td>
        <td id="LC37" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">Delay</span></td>
      </tr>
      <tr>
        <td id="L38" class="blob-num js-line-number" data-line-number="38"></td>
        <td id="LC38" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if Dlytmp/=<span class="pl-c1">0</span> then</td>
      </tr>
      <tr>
        <td id="L39" class="blob-num js-line-number" data-line-number="39"></td>
        <td id="LC39" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">dec</span>(Dlytmp);</td>
      </tr>
      <tr>
        <td id="L40" class="blob-num js-line-number" data-line-number="40"></td>
        <td id="LC40" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(Delay);</td>
      </tr>
      <tr>
        <td id="L41" class="blob-num js-line-number" data-line-number="41"></td>
        <td id="LC41" class="blob-code blob-code-inner js-file-line">   else</td>
      </tr>
      <tr>
        <td id="L42" class="blob-num js-line-number" data-line-number="42"></td>
        <td id="LC42" class="blob-code blob-code-inner js-file-line">     SBARet;</td>
      </tr>
      <tr>
        <td id="L43" class="blob-num js-line-number" data-line-number="43"></td>
        <td id="LC43" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L44" class="blob-num js-line-number" data-line-number="44"></td>
        <td id="LC44" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L45" class="blob-num js-line-number" data-line-number="45"></td>
        <td id="LC45" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2Cwait</span></td>
      </tr>
      <tr>
        <td id="L46" class="blob-num js-line-number" data-line-number="46"></td>
        <td id="LC46" class="blob-code blob-code-inner js-file-line">-- Read Status I2C Module</td>
      </tr>
      <tr>
        <td id="L47" class="blob-num js-line-number" data-line-number="47"></td>
        <td id="LC47" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L48" class="blob-num js-line-number" data-line-number="48"></td>
        <td id="LC48" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2CFlg <span class="pl-k">:=</span> <span class="pl-en">dati</span>(I2C_TXSTA) or <span class="pl-en">dati</span>(I2C_RXSTA);</td>
      </tr>
      <tr>
        <td id="L49" class="blob-num js-line-number" data-line-number="49"></td>
        <td id="LC49" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if I2CFlg =<span class="pl-s">&#39;1&#39;</span> then</td>
      </tr>
      <tr>
        <td id="L50" class="blob-num js-line-number" data-line-number="50"></td>
        <td id="LC50" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L51" class="blob-num js-line-number" data-line-number="51"></td>
        <td id="LC51" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(I2Cwait+<span class="pl-c1">1</span>);</td>
      </tr>
      <tr>
        <td id="L52" class="blob-num js-line-number" data-line-number="52"></td>
        <td id="LC52" class="blob-code blob-code-inner js-file-line">   else SBARet;</td>
      </tr>
      <tr>
        <td id="L53" class="blob-num js-line-number" data-line-number="53"></td>
        <td id="LC53" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L54" class="blob-num js-line-number" data-line-number="54"></td>
        <td id="LC54" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L55" class="blob-num js-line-number" data-line-number="55"></td>
        <td id="LC55" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CWriteByte Routine  ----------------------------</td>
      </tr>
      <tr>
        <td id="L56" class="blob-num js-line-number" data-line-number="56"></td>
        <td id="LC56" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2CWritebyte</span></td>
      </tr>
      <tr>
        <td id="L57" class="blob-num js-line-number" data-line-number="57"></td>
        <td id="LC57" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);                                 -- Read Status I2C Module</td>
      </tr>
      <tr>
        <td id="L58" class="blob-num js-line-number" data-line-number="58"></td>
        <td id="LC58" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2CFlg <span class="pl-k">:=</span> <span class="pl-en">dati</span>(I2C_TXSTA) or <span class="pl-en">dati</span>(I2C_RXSTA);</td>
      </tr>
      <tr>
        <td id="L59" class="blob-num js-line-number" data-line-number="59"></td>
        <td id="LC59" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if I2CFlg =<span class="pl-s">&#39;1&#39;</span> then</td>
      </tr>
      <tr>
        <td id="L60" class="blob-num js-line-number" data-line-number="60"></td>
        <td id="LC60" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L61" class="blob-num js-line-number" data-line-number="61"></td>
        <td id="LC61" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(I2CWritebyte+<span class="pl-c1">1</span>);</td>
      </tr>
      <tr>
        <td id="L62" class="blob-num js-line-number" data-line-number="62"></td>
        <td id="LC62" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L63" class="blob-num js-line-number" data-line-number="63"></td>
        <td id="LC63" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG3,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_DAT);           -- x<span class="pl-s">&quot;00&quot;</span>&amp; I2C_DAT -<span class="pl-k">-&gt;</span> x<span class="pl-s">&quot;00&quot;</span>   = position within the RAM</td>
      </tr>
      <tr>
        <td id="L64" class="blob-num js-line-number" data-line-number="64"></td>
        <td id="LC64" class="blob-code blob-code-inner js-file-line">                				                  --               -<span class="pl-k">-&gt;</span> I2C_DAT = Data to write</td>
      </tr>
      <tr>
        <td id="L65" class="blob-num js-line-number" data-line-number="65"></td>
        <td id="LC65" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG2,x<span class="pl-s">&quot;0000&quot;</span>);                   -- Write One Byte</td>
      </tr>
      <tr>
        <td id="L66" class="blob-num js-line-number" data-line-number="66"></td>
        <td id="LC66" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG1,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ADR_REG);       -- I2C_ADR_REG -<span class="pl-k">-&gt;</span> Initial register address</td>
      </tr>
      <tr>
        <td id="L67" class="blob-num js-line-number" data-line-number="67"></td>
        <td id="LC67" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0<span class="pl-v">,I2C_DEVICE_ADR</span> &amp; x<span class="pl-s">&quot;01&quot;</span> );   -- I2C_DEVICE_ADR &amp; <span class="pl-c1">000000011</span></td>
      </tr>
      <tr>
        <td id="L68" class="blob-num js-line-number" data-line-number="68"></td>
        <td id="LC68" class="blob-code blob-code-inner js-file-line">                                                 --                  <span class="pl-c1">000000011</span> = <span class="pl-s">&quot;000000&quot;</span> &amp; Write &amp; Start</td>
      </tr>
      <tr>
        <td id="L69" class="blob-num js-line-number" data-line-number="69"></td>
        <td id="LC69" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;</td>
      </tr>
      <tr>
        <td id="L70" class="blob-num js-line-number" data-line-number="70"></td>
        <td id="LC70" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBARet;                                       -- Return</td>
      </tr>
      <tr>
        <td id="L71" class="blob-num js-line-number" data-line-number="71"></td>
        <td id="LC71" class="blob-code blob-code-inner js-file-line">---------------------- End I2CWriteByte Routine -------------------------------</td>
      </tr>
      <tr>
        <td id="L72" class="blob-num js-line-number" data-line-number="72"></td>
        <td id="LC72" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L73" class="blob-num js-line-number" data-line-number="73"></td>
        <td id="LC73" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L74" class="blob-num js-line-number" data-line-number="74"></td>
        <td id="LC74" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CReadByte Routine -------------------------------</td>
      </tr>
      <tr>
        <td id="L75" class="blob-num js-line-number" data-line-number="75"></td>
        <td id="LC75" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2CReadbyte</span></td>
      </tr>
      <tr>
        <td id="L76" class="blob-num js-line-number" data-line-number="76"></td>
        <td id="LC76" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);                                -- Read Status I2C Module</td>
      </tr>
      <tr>
        <td id="L77" class="blob-num js-line-number" data-line-number="77"></td>
        <td id="LC77" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2CFlg <span class="pl-k">:=</span> <span class="pl-en">dati</span>(I2C_TXSTA) or <span class="pl-en">dati</span>(I2C_RXSTA);</td>
      </tr>
      <tr>
        <td id="L78" class="blob-num js-line-number" data-line-number="78"></td>
        <td id="LC78" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if I2CFlg =<span class="pl-s">&#39;1&#39;</span> then</td>
      </tr>
      <tr>
        <td id="L79" class="blob-num js-line-number" data-line-number="79"></td>
        <td id="LC79" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L80" class="blob-num js-line-number" data-line-number="80"></td>
        <td id="LC80" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(I2CReadbyte+<span class="pl-c1">1</span>);</td>
      </tr>
      <tr>
        <td id="L81" class="blob-num js-line-number" data-line-number="81"></td>
        <td id="LC81" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L82" class="blob-num js-line-number" data-line-number="82"></td>
        <td id="LC82" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG2,x<span class="pl-s">&quot;0000&quot;</span>);                   -- Read One byte</td>
      </tr>
      <tr>
        <td id="L83" class="blob-num js-line-number" data-line-number="83"></td>
        <td id="LC83" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG1,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ADR_REG);       -- <span class="pl-en">I2C_ADR_REG</span>(Initial  address register)</td>
      </tr>
      <tr>
        <td id="L84" class="blob-num js-line-number" data-line-number="84"></td>
        <td id="LC84" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0, I2C_DEVICE_ADR &amp; x<span class="pl-s">&quot;03&quot;</span> );  -- I2C_DEVICE_ADR &amp; <span class="pl-c1">000000011</span></td>
      </tr>
      <tr>
        <td id="L85" class="blob-num js-line-number" data-line-number="85"></td>
        <td id="LC85" class="blob-code blob-code-inner js-file-line">                                                 --                  <span class="pl-c1">000000011</span> = <span class="pl-s">&quot;000000&quot;</span> &amp; Write &amp; Start</td>
      </tr>
      <tr>
        <td id="L86" class="blob-num js-line-number" data-line-number="86"></td>
        <td id="LC86" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;</td>
      </tr>
      <tr>
        <td id="L87" class="blob-num js-line-number" data-line-number="87"></td>
        <td id="LC87" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);                                 -- Read Status I2C Module</td>
      </tr>
      <tr>
        <td id="L88" class="blob-num js-line-number" data-line-number="88"></td>
        <td id="LC88" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2CFlg <span class="pl-k">:=</span> <span class="pl-en">dati</span>(I2C_TXSTA) or <span class="pl-en">dati</span>(I2C_RXSTA);</td>
      </tr>
      <tr>
        <td id="L89" class="blob-num js-line-number" data-line-number="89"></td>
        <td id="LC89" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if I2CFlg =<span class="pl-s">&#39;1&#39;</span> then</td>
      </tr>
      <tr>
        <td id="L90" class="blob-num js-line-number" data-line-number="90"></td>
        <td id="LC90" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L91" class="blob-num js-line-number" data-line-number="91"></td>
        <td id="LC91" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(I2CReadbyte+<span class="pl-c1">8</span>);</td>
      </tr>
      <tr>
        <td id="L92" class="blob-num js-line-number" data-line-number="92"></td>
        <td id="LC92" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L93" class="blob-num js-line-number" data-line-number="93"></td>
        <td id="LC93" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ReadMEMORY);    -- Enable read memory RAM</td>
      </tr>
      <tr>
        <td id="L94" class="blob-num js-line-number" data-line-number="94"></td>
        <td id="LC94" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;</td>
      </tr>
      <tr>
        <td id="L95" class="blob-num js-line-number" data-line-number="95"></td>
        <td id="LC95" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L96" class="blob-num js-line-number" data-line-number="96"></td>
        <td id="LC96" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait; I2C_DAT<span class="pl-k">:=</span> <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);          -- Save</td>
      </tr>
      <tr>
        <td id="L97" class="blob-num js-line-number" data-line-number="97"></td>
        <td id="LC97" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBARet;                                       -- Return</td>
      </tr>
      <tr>
        <td id="L98" class="blob-num js-line-number" data-line-number="98"></td>
        <td id="LC98" class="blob-code blob-code-inner js-file-line">---------------------- End I2CReadByte Routine --------------------------------</td>
      </tr>
      <tr>
        <td id="L99" class="blob-num js-line-number" data-line-number="99"></td>
        <td id="LC99" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L100" class="blob-num js-line-number" data-line-number="100"></td>
        <td id="LC100" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CwriteBytes Routine ------------------------------</td>
      </tr>
      <tr>
        <td id="L101" class="blob-num js-line-number" data-line-number="101"></td>
        <td id="LC101" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2CWritebytes</span></td>
      </tr>
      <tr>
        <td id="L102" class="blob-num js-line-number" data-line-number="102"></td>
        <td id="LC102" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">if</span> (I2C_ADR_MEMORY<span class="pl-k">&gt;</span><span class="pl-c1">0</span>) then <span class="pl-en">dec</span>(I2C_ADR_MEMORY);</td>
      </tr>
      <tr>
        <td id="L103" class="blob-num js-line-number" data-line-number="103"></td>
        <td id="LC103" class="blob-code blob-code-inner js-file-line">   else SBARet;</td>
      </tr>
      <tr>
        <td id="L104" class="blob-num js-line-number" data-line-number="104"></td>
        <td id="LC104" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L105" class="blob-num js-line-number" data-line-number="105"></td>
        <td id="LC105" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG2,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ADR_MEMORY);     -- Write the number of bytes</td>
      </tr>
      <tr>
        <td id="L106" class="blob-num js-line-number" data-line-number="106"></td>
        <td id="LC106" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG1,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ADR_REG);        -- Initial  address register to Write</td>
      </tr>
      <tr>
        <td id="L107" class="blob-num js-line-number" data-line-number="107"></td>
        <td id="LC107" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0<span class="pl-v">,I2C_DEVICE_ADR</span> &amp; x<span class="pl-s">&quot;01&quot;</span> );    -- I2C_DEVICE_ADR &amp; <span class="pl-c1">000000001</span></td>
      </tr>
      <tr>
        <td id="L108" class="blob-num js-line-number" data-line-number="108"></td>
        <td id="LC108" class="blob-code blob-code-inner js-file-line">                                                  --                  <span class="pl-c1">000000001</span> = <span class="pl-s">&quot;000000&quot;</span> &amp; Write &amp; Start</td>
      </tr>
      <tr>
        <td id="L109" class="blob-num js-line-number" data-line-number="109"></td>
        <td id="LC109" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;</td>
      </tr>
      <tr>
        <td id="L110" class="blob-num js-line-number" data-line-number="110"></td>
        <td id="LC110" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">clr</span>(I2C_ADR_MEMORY);</td>
      </tr>
      <tr>
        <td id="L111" class="blob-num js-line-number" data-line-number="111"></td>
        <td id="LC111" class="blob-code blob-code-inner js-file-line">   SBARet;                                        -- Return</td>
      </tr>
      <tr>
        <td id="L112" class="blob-num js-line-number" data-line-number="112"></td>
        <td id="LC112" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CwriteBytes Routine ------------------------------</td>
      </tr>
      <tr>
        <td id="L113" class="blob-num js-line-number" data-line-number="113"></td>
        <td id="LC113" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L114" class="blob-num js-line-number" data-line-number="114"></td>
        <td id="LC114" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CreadBytes Routine ------------------------------</td>
      </tr>
      <tr>
        <td id="L115" class="blob-num js-line-number" data-line-number="115"></td>
        <td id="LC115" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2CReadbytes</span></td>
      </tr>
      <tr>
        <td id="L116" class="blob-num js-line-number" data-line-number="116"></td>
        <td id="LC116" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">if</span> (I2C_NumberBytesRead<span class="pl-k">&gt;</span><span class="pl-c1">0</span>) then <span class="pl-en">dec</span>(I2C_NumberBytesRead);</td>
      </tr>
      <tr>
        <td id="L117" class="blob-num js-line-number" data-line-number="117"></td>
        <td id="LC117" class="blob-code blob-code-inner js-file-line">   else SBARet;</td>
      </tr>
      <tr>
        <td id="L118" class="blob-num js-line-number" data-line-number="118"></td>
        <td id="LC118" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L119" class="blob-num js-line-number" data-line-number="119"></td>
        <td id="LC119" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG2,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_NumberBytesRead); -- Read the number of bytes</td>
      </tr>
      <tr>
        <td id="L120" class="blob-num js-line-number" data-line-number="120"></td>
        <td id="LC120" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG1,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ADR_REG);         -- Initial  address register</td>
      </tr>
      <tr>
        <td id="L121" class="blob-num js-line-number" data-line-number="121"></td>
        <td id="LC121" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0, I2C_DEVICE_ADR &amp; x<span class="pl-s">&quot;03&quot;</span> );    -- I2C_DEVICE_ADR &amp; <span class="pl-c1">000000011</span></td>
      </tr>
      <tr>
        <td id="L122" class="blob-num js-line-number" data-line-number="122"></td>
        <td id="LC122" class="blob-code blob-code-inner js-file-line">                                                   --                  <span class="pl-c1">000000011</span> = <span class="pl-s">&quot;000000&quot;</span> &amp; Write &amp; Start</td>
      </tr>
      <tr>
        <td id="L123" class="blob-num js-line-number" data-line-number="123"></td>
        <td id="LC123" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;</td>
      </tr>
      <tr>
        <td id="L124" class="blob-num js-line-number" data-line-number="124"></td>
        <td id="LC124" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);                                   -- Read Status I2C Module</td>
      </tr>
      <tr>
        <td id="L125" class="blob-num js-line-number" data-line-number="125"></td>
        <td id="LC125" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2CFlg <span class="pl-k">:=</span> <span class="pl-en">dati</span>(I2C_TXSTA) or <span class="pl-en">dati</span>(I2C_RXSTA);</td>
      </tr>
      <tr>
        <td id="L126" class="blob-num js-line-number" data-line-number="126"></td>
        <td id="LC126" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if I2CFlg =<span class="pl-s">&#39;1&#39;</span> then</td>
      </tr>
      <tr>
        <td id="L127" class="blob-num js-line-number" data-line-number="127"></td>
        <td id="LC127" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L128" class="blob-num js-line-number" data-line-number="128"></td>
        <td id="LC128" class="blob-code blob-code-inner js-file-line">     <span class="pl-en">SBAjump</span>(I2CReadbytes+<span class="pl-c1">6</span>);</td>
      </tr>
      <tr>
        <td id="L129" class="blob-num js-line-number" data-line-number="129"></td>
        <td id="LC129" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L130" class="blob-num js-line-number" data-line-number="130"></td>
        <td id="LC130" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG0,x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_ReadMEMORY);      -- Enable read memory RAM</td>
      </tr>
      <tr>
        <td id="L131" class="blob-num js-line-number" data-line-number="131"></td>
        <td id="LC131" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">clr</span>(I2C_NumberBytesRead);</td>
      </tr>
      <tr>
        <td id="L132" class="blob-num js-line-number" data-line-number="132"></td>
        <td id="LC132" class="blob-code blob-code-inner js-file-line">   SBAwait;</td>
      </tr>
      <tr>
        <td id="L133" class="blob-num js-line-number" data-line-number="133"></td>
        <td id="LC133" class="blob-code blob-code-inner js-file-line">   SBARet;</td>
      </tr>
      <tr>
        <td id="L134" class="blob-num js-line-number" data-line-number="134"></td>
        <td id="LC134" class="blob-code blob-code-inner js-file-line">---------------------- Init I2CReadbytes Routine ------------------------------</td>
      </tr>
      <tr>
        <td id="L135" class="blob-num js-line-number" data-line-number="135"></td>
        <td id="LC135" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L136" class="blob-num js-line-number" data-line-number="136"></td>
        <td id="LC136" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">I2CLoadbyteToMEMORY</span></td>
      </tr>
      <tr>
        <td id="L137" class="blob-num js-line-number" data-line-number="137"></td>
        <td id="LC137" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(I2C_REG3<span class="pl-v">,I2C_ADR_MEMORY</span> &amp; I2C_DAT);</td>
      </tr>
      <tr>
        <td id="L138" class="blob-num js-line-number" data-line-number="138"></td>
        <td id="LC138" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">inc</span>(I2C_ADR_MEMORY); SBARet;</td>
      </tr>
      <tr>
        <td id="L139" class="blob-num js-line-number" data-line-number="139"></td>
        <td id="LC139" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L140" class="blob-num js-line-number" data-line-number="140"></td>
        <td id="LC140" class="blob-code blob-code-inner js-file-line">------------------------------ MAIN PROGRAM ------------------------------------</td>
      </tr>
      <tr>
        <td id="L141" class="blob-num js-line-number" data-line-number="141"></td>
        <td id="LC141" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L142" class="blob-num js-line-number" data-line-number="142"></td>
        <td id="LC142" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">Init</span></td>
      </tr>
      <tr>
        <td id="L143" class="blob-num js-line-number" data-line-number="143"></td>
        <td id="LC143" class="blob-code blob-code-inner js-file-line">-- Turn On ADXL345, I2C Write Byte Sequence</td>
      </tr>
      <tr>
        <td id="L144" class="blob-num js-line-number" data-line-number="144"></td>
        <td id="LC144" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DEVICE_ADR<span class="pl-k">:=</span>x<span class="pl-s">&quot;53&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L145" class="blob-num js-line-number" data-line-number="145"></td>
        <td id="LC145" class="blob-code blob-code-inner js-file-line">   I2C_ADR_REG<span class="pl-k">:=</span>x<span class="pl-s">&quot;2D&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L146" class="blob-num js-line-number" data-line-number="146"></td>
        <td id="LC146" class="blob-code blob-code-inner js-file-line">   I2C_DAT<span class="pl-k">:=</span>x<span class="pl-s">&quot;08&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L147" class="blob-num js-line-number" data-line-number="147"></td>
        <td id="LC147" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CWritebyte);</td>
      </tr>
      <tr>
        <td id="L148" class="blob-num js-line-number" data-line-number="148"></td>
        <td id="LC148" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L149" class="blob-num js-line-number" data-line-number="149"></td>
        <td id="LC149" class="blob-code blob-code-inner js-file-line">-- Read Device ID ADXL345, I2C Read Byte Sequence</td>
      </tr>
      <tr>
        <td id="L150" class="blob-num js-line-number" data-line-number="150"></td>
        <td id="LC150" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DEVICE_ADR <span class="pl-k">:=</span>x<span class="pl-s">&quot;53&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L151" class="blob-num js-line-number" data-line-number="151"></td>
        <td id="LC151" class="blob-code blob-code-inner js-file-line">   I2C_ADR_REG<span class="pl-k">:=</span>x<span class="pl-s">&quot;00&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L152" class="blob-num js-line-number" data-line-number="152"></td>
        <td id="LC152" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CReadbyte);</td>
      </tr>
      <tr>
        <td id="L153" class="blob-num js-line-number" data-line-number="153"></td>
        <td id="LC153" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO, x<span class="pl-s">&quot;00&quot;</span> &amp; I2C_DAT);</td>
      </tr>
      <tr>
        <td id="L154" class="blob-num js-line-number" data-line-number="154"></td>
        <td id="LC154" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L155" class="blob-num js-line-number" data-line-number="155"></td>
        <td id="LC155" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">SuperDelay</span></td>
      </tr>
      <tr>
        <td id="L156" class="blob-num js-line-number" data-line-number="156"></td>
        <td id="LC156" class="blob-code blob-code-inner js-file-line">-- Delay <span class="pl-c1">1</span> second</td>
      </tr>
      <tr>
        <td id="L157" class="blob-num js-line-number" data-line-number="157"></td>
        <td id="LC157" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> reg1<span class="pl-k">:=</span>x<span class="pl-s">&quot;03E8&quot;</span>;   -- <span class="pl-c1">1000</span> * <span class="pl-c1">50000</span> = 50E6 cycles = <span class="pl-c1">1</span> seg</td>
      </tr>
      <tr>
        <td id="L158" class="blob-num js-line-number" data-line-number="158"></td>
        <td id="LC158" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> Dlytmp<span class="pl-k">:=</span>x<span class="pl-s">&quot;C350&quot;</span>; -- <span class="pl-c1">50</span>,<span class="pl-c1">000</span> cycles</td>
      </tr>
      <tr>
        <td id="L159" class="blob-num js-line-number" data-line-number="159"></td>
        <td id="LC159" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBACall</span>(Delay);</td>
      </tr>
      <tr>
        <td id="L160" class="blob-num js-line-number" data-line-number="160"></td>
        <td id="LC160" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> if reg1/=<span class="pl-c1">0</span> then</td>
      </tr>
      <tr>
        <td id="L161" class="blob-num js-line-number" data-line-number="161"></td>
        <td id="LC161" class="blob-code blob-code-inner js-file-line">    <span class="pl-en">dec</span>(reg1);</td>
      </tr>
      <tr>
        <td id="L162" class="blob-num js-line-number" data-line-number="162"></td>
        <td id="LC162" class="blob-code blob-code-inner js-file-line">    <span class="pl-en">SBAjump</span>(SuperDelay+<span class="pl-c1">1</span>);</td>
      </tr>
      <tr>
        <td id="L163" class="blob-num js-line-number" data-line-number="163"></td>
        <td id="LC163" class="blob-code blob-code-inner js-file-line">   end if;</td>
      </tr>
      <tr>
        <td id="L164" class="blob-num js-line-number" data-line-number="164"></td>
        <td id="LC164" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L165" class="blob-num js-line-number" data-line-number="165"></td>
        <td id="LC165" class="blob-code blob-code-inner js-file-line">-- Multiple Write I2C</td>
      </tr>
      <tr>
        <td id="L166" class="blob-num js-line-number" data-line-number="166"></td>
        <td id="LC166" class="blob-code blob-code-inner js-file-line">-- Data to write up to <span class="pl-c1">256</span></td>
      </tr>
      <tr>
        <td id="L167" class="blob-num js-line-number" data-line-number="167"></td>
        <td id="LC167" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAcall</span>(I2Cwait);             -- Is the I2C module avaliable?</td>
      </tr>
      <tr>
        <td id="L168" class="blob-num js-line-number" data-line-number="168"></td>
        <td id="LC168" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_ADR_MEMORY<span class="pl-k">:=</span>x<span class="pl-s">&quot;00&quot;</span>;        -- Reset address internal memory.</td>
      </tr>
      <tr>
        <td id="L169" class="blob-num js-line-number" data-line-number="169"></td>
        <td id="LC169" class="blob-code blob-code-inner js-file-line">   I2C_DAT<span class="pl-k">:=</span>x<span class="pl-s">&quot;00&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L170" class="blob-num js-line-number" data-line-number="170"></td>
        <td id="LC170" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CLoadbyteToMEMORY); -- Load data within internal memory</td>
      </tr>
      <tr>
        <td id="L171" class="blob-num js-line-number" data-line-number="171"></td>
        <td id="LC171" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DAT<span class="pl-k">:=</span>x<span class="pl-s">&quot;02&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L172" class="blob-num js-line-number" data-line-number="172"></td>
        <td id="LC172" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CLoadbyteToMEMORY); -- Load data within internal memory</td>
      </tr>
      <tr>
        <td id="L173" class="blob-num js-line-number" data-line-number="173"></td>
        <td id="LC173" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DAT<span class="pl-k">:=</span>x<span class="pl-s">&quot;25&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L174" class="blob-num js-line-number" data-line-number="174"></td>
        <td id="LC174" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CLoadbyteToMEMORY); -- Load data within internal memory</td>
      </tr>
      <tr>
        <td id="L175" class="blob-num js-line-number" data-line-number="175"></td>
        <td id="LC175" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DEVICE_ADR <span class="pl-k">:=</span>x<span class="pl-s">&quot;53&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L176" class="blob-num js-line-number" data-line-number="176"></td>
        <td id="LC176" class="blob-code blob-code-inner js-file-line">   I2C_ADR_REG<span class="pl-k">:=</span>x<span class="pl-s">&quot;1E&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L177" class="blob-num js-line-number" data-line-number="177"></td>
        <td id="LC177" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBAcall</span>(I2CWritebytes);       -- Call routine I2CWriteBytes</td>
      </tr>
      <tr>
        <td id="L178" class="blob-num js-line-number" data-line-number="178"></td>
        <td id="LC178" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L179" class="blob-num js-line-number" data-line-number="179"></td>
        <td id="LC179" class="blob-code blob-code-inner js-file-line">-- Multiple Read I2C of ADXL345</td>
      </tr>
      <tr>
        <td id="L180" class="blob-num js-line-number" data-line-number="180"></td>
        <td id="LC180" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAcall</span>(I2Cwait);             -- Is the I2C module avaliable?</td>
      </tr>
      <tr>
        <td id="L181" class="blob-num js-line-number" data-line-number="181"></td>
        <td id="LC181" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_DEVICE_ADR <span class="pl-k">:=</span>x<span class="pl-s">&quot;53&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L182" class="blob-num js-line-number" data-line-number="182"></td>
        <td id="LC182" class="blob-code blob-code-inner js-file-line">   I2C_ADR_REG<span class="pl-k">:=</span>x<span class="pl-s">&quot;32&quot;</span>;</td>
      </tr>
      <tr>
        <td id="L183" class="blob-num js-line-number" data-line-number="183"></td>
        <td id="LC183" class="blob-code blob-code-inner js-file-line">-- /<span class="pl-v">L</span>:<span class="pl-v">ReadBucle</span></td>
      </tr>
      <tr>
        <td id="L184" class="blob-num js-line-number" data-line-number="184"></td>
        <td id="LC184" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> I2C_NumberBytesRead<span class="pl-k">:=</span>x<span class="pl-s">&quot;06&quot;</span>;   -- Numbers bytes to Read</td>
      </tr>
      <tr>
        <td id="L185" class="blob-num js-line-number" data-line-number="185"></td>
        <td id="LC185" class="blob-code blob-code-inner js-file-line">   <span class="pl-en">SBACall</span>(I2CReadbytes);        -- Call I2CReadBytes Routine</td>
      </tr>
      <tr>
        <td id="L186" class="blob-num js-line-number" data-line-number="186"></td>
        <td id="LC186" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(I2C);</td>
      </tr>
      <tr>
        <td id="L187" class="blob-num js-line-number" data-line-number="187"></td>
        <td id="LC187" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg1<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- first data    <span class="pl-en">X</span> (LSB)</td>
      </tr>
      <tr>
        <td id="L188" class="blob-num js-line-number" data-line-number="188"></td>
        <td id="LC188" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg2<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- second data   <span class="pl-en">X</span> (MSB)</td>
      </tr>
      <tr>
        <td id="L189" class="blob-num js-line-number" data-line-number="189"></td>
        <td id="LC189" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg3<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- third data    <span class="pl-en">Y</span> (LSB)</td>
      </tr>
      <tr>
        <td id="L190" class="blob-num js-line-number" data-line-number="190"></td>
        <td id="LC190" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg4<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- Fourth data   <span class="pl-en">Y</span> (MSB)</td>
      </tr>
      <tr>
        <td id="L191" class="blob-num js-line-number" data-line-number="191"></td>
        <td id="LC191" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg5<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- fifth data    <span class="pl-en">Z</span> (LSB)</td>
      </tr>
      <tr>
        <td id="L192" class="blob-num js-line-number" data-line-number="192"></td>
        <td id="LC192" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> SBAwait;  reg6<span class="pl-k">:=</span> x<span class="pl-s">&quot;00&quot;</span> &amp; <span class="pl-en">dati</span>(<span class="pl-c1">7</span> downto <span class="pl-c1">0</span>);  -- sixth data    <span class="pl-en">Z</span> (MSB)</td>
      </tr>
      <tr>
        <td id="L193" class="blob-num js-line-number" data-line-number="193"></td>
        <td id="LC193" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBARead</span>(GPIO2);					           -- Read the status of the switches</td>
      </tr>
      <tr>
        <td id="L194" class="blob-num js-line-number" data-line-number="194"></td>
        <td id="LC194" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> reg7<span class="pl-k">:=</span> <span class="pl-en">dati</span>(<span class="pl-c1">2</span> downto <span class="pl-c1">0</span>);      </td>
      </tr>
      <tr>
        <td id="L195" class="blob-num js-line-number" data-line-number="195"></td>
        <td id="LC195" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> case reg7 is                                -- Evaluating the status of the switches</td>
      </tr>
      <tr>
        <td id="L196" class="blob-num js-line-number" data-line-number="196"></td>
        <td id="LC196" class="blob-code blob-code-inner js-file-line">	  when <span class="pl-s">&quot;000&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg1);       -- Displaying <span class="pl-en">X</span>(LSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L197" class="blob-num js-line-number" data-line-number="197"></td>
        <td id="LC197" class="blob-code blob-code-inner js-file-line">      when <span class="pl-s">&quot;001&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg2);       -- Displaying <span class="pl-en">X</span>(MSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L198" class="blob-num js-line-number" data-line-number="198"></td>
        <td id="LC198" class="blob-code blob-code-inner js-file-line"> 	  when <span class="pl-s">&quot;010&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg3);       -- Displaying <span class="pl-en">Y</span>(LSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L199" class="blob-num js-line-number" data-line-number="199"></td>
        <td id="LC199" class="blob-code blob-code-inner js-file-line">	  when <span class="pl-s">&quot;011&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg4);       -- Displaying <span class="pl-en">Y</span>(MSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L200" class="blob-num js-line-number" data-line-number="200"></td>
        <td id="LC200" class="blob-code blob-code-inner js-file-line">	  when <span class="pl-s">&quot;100&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg5);       -- Displaying <span class="pl-en">Z</span>(LSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L201" class="blob-num js-line-number" data-line-number="201"></td>
        <td id="LC201" class="blob-code blob-code-inner js-file-line">	  when <span class="pl-s">&quot;101&quot;</span> =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,reg6);       -- Displaying <span class="pl-en">Z</span>(MSB) data to the LEDs</td>
      </tr>
      <tr>
        <td id="L202" class="blob-num js-line-number" data-line-number="202"></td>
        <td id="LC202" class="blob-code blob-code-inner js-file-line">	  when others =<span class="pl-k">&gt;</span> <span class="pl-en">SBAWrite</span>(GPIO,x<span class="pl-s">&quot;0055&quot;</span>);   -- <span class="pl-c1">Any</span> data</td>
      </tr>
      <tr>
        <td id="L203" class="blob-num js-line-number" data-line-number="203"></td>
        <td id="LC203" class="blob-code blob-code-inner js-file-line">   end case;</td>
      </tr>
      <tr>
        <td id="L204" class="blob-num js-line-number" data-line-number="204"></td>
        <td id="LC204" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L205" class="blob-num js-line-number" data-line-number="205"></td>
        <td id="LC205" class="blob-code blob-code-inner js-file-line">=<span class="pl-k">&gt;</span> <span class="pl-en">SBAjump</span>(ReadBucle);</td>
      </tr>
      <tr>
        <td id="L206" class="blob-num js-line-number" data-line-number="206"></td>
        <td id="LC206" class="blob-code blob-code-inner js-file-line">
</td>
      </tr>
      <tr>
        <td id="L207" class="blob-num js-line-number" data-line-number="207"></td>
        <td id="LC207" class="blob-code blob-code-inner js-file-line">-- /SBA: End -------------------------------------------------------------------</td>
      </tr>
</table>

  </div>

</div>

<a href="#jump-to-line" rel="facebox[.linejump]" data-hotkey="l" style="display:none">Jump to Line</a>
<div id="jump-to-line" style="display:none">
  <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="" class="js-jump-to-line-form" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    <input class="linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" aria-label="Jump to line" autofocus>
    <button type="submit" class="btn">Go</button>
</form></div>

          </div>
        </div>
        <div class="modal-backdrop"></div>
      </div>
  </div>


    </div><!-- /.wrapper -->

      <div class="container">
  <div class="site-footer" role="contentinfo">
    <ul class="site-footer-links right">
        <li><a href="https://status.github.com/" data-ga-click="Footer, go to status, text:status">Status</a></li>
      <li><a href="https://developer.github.com" data-ga-click="Footer, go to api, text:api">API</a></li>
      <li><a href="https://training.github.com" data-ga-click="Footer, go to training, text:training">Training</a></li>
      <li><a href="https://shop.github.com" data-ga-click="Footer, go to shop, text:shop">Shop</a></li>
        <li><a href="https://github.com/blog" data-ga-click="Footer, go to blog, text:blog">Blog</a></li>
        <li><a href="https://github.com/about" data-ga-click="Footer, go to about, text:about">About</a></li>
        <li><a href="https://help.github.com" data-ga-click="Footer, go to help, text:help">Help</a></li>

    </ul>

    <a href="https://github.com" aria-label="Homepage">
      <span class="mega-octicon octicon-mark-github" title="GitHub"></span>
</a>
    <ul class="site-footer-links">
      <li>&copy; 2015 <span title="0.13051s from github-fe117-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="https://github.com/site/terms" data-ga-click="Footer, go to terms, text:terms">Terms</a></li>
        <li><a href="https://github.com/site/privacy" data-ga-click="Footer, go to privacy, text:privacy">Privacy</a></li>
        <li><a href="https://github.com/security" data-ga-click="Footer, go to security, text:security">Security</a></li>
        <li><a href="https://github.com/contact" data-ga-click="Footer, go to contact, text:contact">Contact</a></li>
    </ul>
  </div>
</div>


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-suggester-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="fullscreen-contents js-fullscreen-contents" placeholder="" aria-label=""></textarea>
      <div class="suggester-container">
        <div class="suggester fullscreen-suggester js-suggester js-navigation-container"></div>
      </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped tooltipped-w" aria-label="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped tooltipped-w"
      aria-label="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    
    
    

    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      <a href="#" class="octicon octicon-x flash-close js-ajax-error-dismiss" aria-label="Dismiss error"></a>
      Something went wrong with that request. Please try again.
    </div>


      <script crossorigin="anonymous" src="https://assets-cdn.github.com/assets/frameworks-f2cb750ff18baf4484f1f3d872019c51964030f451d1896031c4855ee4380d5c.js"></script>
      <script async="async" crossorigin="anonymous" src="https://assets-cdn.github.com/assets/github/index-2c3b28fb3ba2bddd68f333b8bb58c839e9ebaaecd68e845d191e31d3c6c8179b.js"></script>
      
      
  </body>
</html>

