<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Pi.Mill</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="">

	<!--link rel="stylesheet/less" href="less/bootstrap.less" type="text/css" /-->
	<!--link rel="stylesheet/less" href="less/responsive.less" type="text/css" /-->
	<!--script src="js/less-1.3.3.min.js"></script-->
	<!--append ‘#!watch’ to the browser URL, then refresh the page. -->
	
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/style.css" rel="stylesheet">

  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
  <![endif]-->

  <!-- Fav and touch icons -->
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="img/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/apple-touch-icon-114-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/apple-touch-icon-72-precomposed.png">
  <link rel="apple-touch-icon-precomposed" href="img/apple-touch-icon-57-precomposed.png">
  <link rel="shortcut icon" href="img/favicon.png">
  
	<script type="text/javascript" src="js/jquery.min.js"></script>
    <script src="js/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/sockjs-0.3.4.min.js"charset="utf-8"></script>
    <script type="text/javascript" src="js/pimillclient.js" charset="utf-8"></script>
    <script src="js/pimillgui.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="js/scripts.js"></script>
    
    
</head>

<body>
    
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
	<div class="navbar-header">
		 <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"> <span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button> <a class="navbar-brand" href="#">Pi.<span style="color: green">Mill</span></a>
	</div>
	
	
	
</nav>
    
    
<div class="container" id="page-container">
	<div class="row clearfix">
		<div class="col-sm-4 column" id="side-panels">
			<div class="panel panel-default" id="panel-connection">
				<div class="panel-heading">
					<h3 class="panel-title">
						<a data-toggle="collapse" data-parent="#side-panels" href="#panel-connection-body"> Connection <span class="pull-right glyphicon glyphicon-chevron-down"></span></a>
					</h3>
				</div>
				<div class="panel-body panel-collapse collapse in" id="panel-connection-body">
                    <form role="form">
                      <div class="form-group">
                          <label for="serial">Serial port:</label> 
                          <select name="serials" class="serials form-control"><option>/dev/tty.usb</option></select>
                      </div>

                    </form>
				</div>

			</div>
			<div class="panel panel-default" id="panel-settings">
				<div class="panel-heading">
					<h3 class="panel-title">
						 <a  data-toggle="collapse" data-parent="#side-panels" href="#panel-settings-body">Settings  <span class="pull-right glyphicon glyphicon-chevron-down"></span></a>
					</h3>
				</div>
				<div class="panel-body panel-collapse collapse " id="panel-settings-body">
					<strong>Preset:</strong><br/><select name="presets" class="form-control"><option>Etch board 1/64''</option></select> <br/>
                    <a href="#panel-settings-detail" class="pull-right" data-toggle="collapse">Advanced</a>
                    <div class="collapse" id="panel-settings-detail">
                   <strong>Path options</strong><br/>
                    Offset:<br/> <input type="text" class="form-control" name="settings_offset" size="4"><br/>
                   <strong>Milling options</strong><br/>
                       <div class="row">
                           <div class="col-sm-6 column">
                               Speed:<br/> <input type="text" class="form-control" name="settings_speed" size="4">
                            </div>
                           <div class="col-sm-6 column">
                               Jog:<br/> <input type="text" class="form-control" name="settings_jog" size="4"><br/>
                            </div>
                            <div class="col-sm-12 column">
                                Path type:<br/>
                                <select name="settings_path_type">
                                    <option>2D</option>
                                    <option>3D plane</option>
                                    <option>3D rough</option>
                                </select>
                            </div>
                        </div>
                    </div>
				</div>
			</div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><a data-toggle="collapse" data-parent="#side-panels"  href="#panel-head-body"> Head position <span class="pull-right glyphicon glyphicon-chevron-down"></span></a></h3>
                </div>
                <div class="panel-body panel-collapse collapse " id="panel-head-body">
                     <div class="row">
                         
                         <div class="col-sm-6 column">
                             <div class="input-group input-group-sm">
                               <span class="input-group-addon">X</span>
                               <input type="text" name="head_x"  class="form-control" value="20" placeholder="20">
                             </div>
                         </div>
                         <div class="col-sm-6 column">
                             <div class="input-group input-group-sm">
                               <span class="input-group-addon">Y</span>
                               <input type="text" name="head_y"  class="form-control" value="20" placeholder="20">
                             </div>
                         </div>
                    </div>
                    <hr/>
                    <button id="moveButton" class="btn btn-primary pull-right">Move</button>
                </div>
            </div>
			<div class="panel panel-default" id="panel-status">
				<div class="panel-heading">
					<h3 class="panel-title">
						 <a data-toggle="collapse" data-parent="#side-panels" href="#panel-status-body">Status <span class="pull-right glyphicon glyphicon-chevron-down"></span></a>
					</h3>
				</div>
				<div class="panel-body panel-collapse collapse " id="panel-status-body">
					<span id="millStatus">Idle</span><br/>
                    Total time: <span id="millTotal">00:00:00</span><br/>
                    Time left: <span id="millRem">00:00:00</span><br/>
               
                    
                    
				</div>
			</div>
		</div>  
	    <div class="col-sm-8 column">
    		<div class="tabbable" id="tabs-229724">
    			<ul class="nav nav-tabs">
    				<li class="active">
    					<a href="#panel-input" data-toggle="tab">Input file</a>
    				</li>
    				<li>
    					<a href="#panel-path" data-toggle="tab">Milling path</a>
    				</li>
    				<li>
    					<a href="#panel-rml" data-toggle="tab">RML</a>
    				</li>
    			</ul>
    			<div class="tab-content">
    				<div class="tab-pane active" id="panel-input">
                        <div id="panel-input-preview">
                             <div class="text-center">   <img src="/img/please.png"> </div>
                        </div>
                        <br/>
                            <div class="row">
                               
                                <div class="col-sm-12 column">
                                    <div class="well clearfix">
                                            <strong>Input file</strong>
                                            <form id="uploadForm" enctype="multipart/form-data">
                                            <input class="form-control" name="upload" type="file"> <br/>
                                            <button id="uploadButton" class="pull-right btn btn-primary">Upload file</button>
                                            </form>
                                    </div>
                                
                                </div>
                             <div class="col-sm-12 column">
                                    <div class="well">
                                        <strong>File info:</strong><br/><span id="uploadInfo1">No file selected</span><br/>
                                        <strong>Geometry:</strong><br/><span id="uploadInfo2">n.a.</span>
                                        <hr>
                                            <button class="btn btn-primary">Resize</button>
                                            <button class="btn btn-secondary" id="invertButton">Invert</button>
                                            <button id="makePathButton" class="btn btn-success pull-right">Make path</button>
                                    </div>
                                </div></div>

                        <hr>
                        
                    </div>
    				<div class="tab-pane" id="panel-path">
                        <div id="panel-path-preview">
                            
                        </div>
                        <br/>
                        <!-- <button class="btn btn-secondary pull-left">Back</button>                         -->
                        <button id="makeRmlButton" class="btn btn-success pull-right">Make RML</button>
    				</div>
    				<div class="tab-pane" id="panel-rml">
                        <div id="panel-rml-preview">
                           
                        </div>

                        <br>   
                        <div class="row">
                            <div class="col-sm-4 columns">
                                Progress
                            </div>
                            <div class="col-sm-8 columns">
                            <div class="progress progress-striped">
                              <div class="progress-bar progress-bar-success" id="millProgress" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
                                <span class="sr-only">0% Complete</span>
                              </div>
                            </div>
                            </div>
                        </div>
                        <br>
                        <!-- <button class="btn btn-secondary pull-left">Back</button>    -->
                        <div class="pull-right">
                                          
                        <button class="btn btn-primary" id="startMillingButton">Begin milling</button>
                        <button class="btn btn-danger" id="stopMillingButton">Cancel</button>
                        </div>
    				</div>
    			</div>
    		</div>
	    </div> <!-- column -->
    </div> <!-- row -->

	
    
    
</div>
</body>
</html>
