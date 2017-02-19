<%--
  Created by IntelliJ IDEA.
  User: kh0ma
  Date: 11.02.17
  Time: 18:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>ToDo List</title>
    <link rel="stylesheet" href="webjars/datatables/1.10.12/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="webjars/bootstrap/3.3.7-1/css/bootstrap.css">

    <script type="text/javascript" src="webjars/jquery/3.1.0/jquery.min.js"></script>
    <script type="text/javascript" src="webjars/bootstrap/3.3.7-1/js/bootstrap.min.js"></script>
    <style>
        /* Remove the navbar's default margin-bottom and rounded borders */
        .navbar {
            margin-bottom: 0;
            border-radius: 0;
            color: black;
        }

        /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
        .row.content {height: 100%}


        /* Set black background color, white text and some padding */
        footer {
            padding: 15px;
        }

        /* On small screens, set height to 'auto' for sidenav and grid */
        @media screen and (max-width: 767px) {
            .sidenav {
                height: auto;
                padding: 15px;
            }
            .row.content {height:100%;}
        }

        html {
            background: url(/resources/images/bg.jpg) no-repeat center center fixed;
            -webkit-background-size: cover;
            -moz-background-size: cover;
            -o-background-size: cover;
            background-size: cover;
        }

        .tasks-table
        {
            width: 100%;
            margin: -1px 0 0;
        }

        .tasks-row
        {
            border-top: 1px solid #E7EBEA;
            background: #fff;
            height: 48px;
        }

        .table-checkBox
        {
            border-right: 1px solid #EFDADF;
            width: 40px;
            text-align: center;
            position: relative;
        }

        .table-name
        {
            font-size: 13px;
            line-height: 120%;
            font-weight: bold;
            color: #999;
            padding: 0;
            word-wrap: break-word;
            word-break: break-all;
            table-layout: fixed;
        }
        .table-controls
        {
            width: 120px;
            border-left: 1px solid #e7ebea;
            text-align: center;
            padding: 4px 0 0;
        }

        table {
            border-collapse: collapse;
            border-spacing: 0;
        }

        body {
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14px;
            line-height: 1.42857143;
            color: #333333;
            background-color: #fff;
        }

        .table-name .left-border {
            border-left: 1px solid #EFDADF;
            margin: 0 0 0 2px;
            padding: 4px;
            height: 48px;
        }

        .table-name .task-name-text{
            display: block;
            border: 0;
            padding: 11px 10px;
            border-radius: 3px;
            outline: none;
            width: 100%;
        }

        .edit-task-checkbox {
            height: initial;
            width:  inherit;
        }

    </style>
</head>
<body style="background: inherit">

<nav class="navbar navbar-transparen">
    <div class="container-fluid">
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> LogOut</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid text-center container-transparen">
    <div class="row content" >
        <div class="col-sm-6 text-center col-sm-offset-3">
            <div style="height: 70pt">
                <h1>TODO LIST</h1>

            </div>
            <%--<c:forEach items="${projects}" var="project">
                <jsp:useBean id="project" scope="page" type="com.herokuapp.todolistkh0ma.model.Project"/>
                <div class="row">
                    <div class="panel panel-group">
                        <div class="panel panel-default">
                            <div class="panel-heading" style="background: #3434a0; color: white">${project.name}</div>
                            <c:forEach items="${project.tasks}" var="task">
                                <jsp:useBean id="task" scope="page" type="com.herokuapp.todolistkh0ma.model.Task"/>
                                <div class="panel-body">
                                        ${task.name}
                                </div>
                            </c:forEach>
                            <div class="panel-footer">Panel Footer</div>
                        </div>
                    </div>
                </div>
            </c:forEach>--%>

            <div id="ajax_project_load"></div>
            <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#addProject">
                <span class='glyphicon glyphicon-plus-sign'></span>&nbspADD PROJECT
            </button>


        </div>
    </div>
</div>

<footer class="container-fluid text-center">
    <p>© kh0ma 2017</p>
</footer>

<!-- Modal Add Project -->
<div class="modal fade" id="addProject" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Add Project</h4>
            </div>
            <div class="modal-body">
                <form class="form-inline">
                    <div class="form-group">
                        <label class="control-label" for="addProjectName" style="align-self: center;">Name:</label>
                        <input type="text" class="form-control" id="addProjectName">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-large btn-primary" type="button" data-dismiss="modal" onclick="addProject()">Ok</button>
                <button type="submit" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Edit Project -->
<div class="modal fade" id="editProject" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Edit Project</h4>
            </div>
            <div class="modal-body">
                <form class="form-inline">
                    <div class="form-group">
                        <label class="control-label" for="editProjectName" style="align-self: center;">Name:</label>
                        <input type="text" class="form-control" id="editProjectName">
                        <input type="hidden" id="editProjectId">
                        <input type="hidden" id="editProjectCreated">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-large btn-primary" type="button" data-dismiss="modal" onclick="updateProject()">Ok</button>
                <button type="submit" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Edit Task -->
<div class="modal fade" id="editTask" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Edit Task</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <input type="hidden" id="editTaskId">
                    <input type="hidden" id="editTaskCreated">
                    <input type="hidden" id="editTaskPriority">
                    <input type="hidden" id="editTaskProjectId">
                    <div class="form-group">
                        <label class="control-label col-sm-3" for="editTaskName" style="align-self: center;">Name:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="editTaskName">
                        </div>
                    </div>
                    <div  class="form-group">
                        <label class="control-label col-sm-3" for="editTaskIsDone" style="align-self: center;">Is Completed?</label>
                        <div class="col-sm-9">
                            <div class="checkbox pull-left ">
                                <label>
                                    <input type="checkbox" class="form-control edit-task-checkbox" id="editTaskIsDone">
                                </label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-large btn-primary" type="button" data-dismiss="modal" onclick="updateTask()">Ok</button>
                <button type="submit" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Hidden div -->
<div hidden>
    <div id="projectRow_projectId_" class="row">
        <div class="panel panel-group">
            <div class="panel panel-heading" style="background: #3434a0; color: white">
                <span class='glyphicon glyphicon-tasks'></span>
                <strong id='projectHeaderName_projectId_'>

                </strong>
                <a id='deleteProject_projectId_' onClick='deleteProject(this.id.split("_")[1])' type='button'>
                    <span class='glyphicon glyphicon-trash'></span>
                </a>
                <a id='editProject_projectId_' onClick='editProject(this.id)' data-toggle='modal' data-target='#editProject'>
                    <span class='glyphicon glyphicon-pencil'></span>
                </a>
            </div>
            <div id='addTaskPanel' class='input-group'>
                <input type='text' class='form-control' placeholder='Start typing here to create a task...' id='addTaskInput_projectId_'>
                <span class='input-group-btn' for='addTaskInput_projectId_'>
                <button class='btn' type='submit' onclick='addTask(this.id)' id='addTaskButton_projectId_'>Add</button>
                </span>
            </div>
            <table id='tableTasks' class='tasks-table'>
                <tbody id='tbody_projectId_'>

                </tbody>
            </table>
        </div>
    </div>

    <table>
        <tr class='tasks-row' id='row_taskId_'>
        <td class='table-checkBox'>
            <input type="checkbox" id='checkBox_taskId_projectId_'>
        </td>
        <td class='table-name'>
            <div class='left-border'>
                <div class='task-name-text' id='nameDiv_taskId_'>

                </div>
            </div>
        </td>
        <td class='table-controls' id='controls_taskId_'>
            <a id='editTask_taskId_projectId_' onClick="editTask(this.id.split('_')[2], this.id.split('_')[1])" data-toggle='modal' data-target='#editTask'><span class='glyphicon glyphicon-pencil'></span></a>
            <a id='deleteTask_taskId_projectId_' onClick="deleteTask(this.id.split('_')[2],this.id.split('_')[1])" type="button"><span class='glyphicon glyphicon-trash'></span></a>
        </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    var ajaxUrl = 'ajax/profile/projects/';

    var projectRow = $("#projectRow_projectId_").prop('outerHTML');

    var tableRow = $("#row_taskId_").prop('outerHTML');

    function editTask(projectId,taskId) {
        $.ajax({
            dataType: "json",
            url: ajaxUrl+projectId + "/tasks/" + taskId,
            data: null,
            success: function(data) {
                $("#editTaskName").val(data.name);
                $("#editTaskId").val(data.id);
                $("#editTaskCreated").val(data.created);
                $("#editTaskPriority").val(data.priority);
                $("#editTaskProjectId").val(projectId);
                $("#editTaskIsDone").prop("checked",data.done);
            }
        })
    }

    function editProject(button_id) {
        var projectID = button_id.replace("editProject_","");
        $.ajax({
            dataType: "json",
            url: ajaxUrl+projectID,
            data: null,
            success: function(data) {
                $("#editProjectName").val(data.name);
                $("#editProjectId").val(data.id);
                $("#editProjectCreated").val(data.created);
            }
        })
    }

    function updateTask() {
        var name = $("#editTaskName").val();
        var id = $("#editTaskId").val();
        var created = $("#editTaskCreated").val();
        var priority = $("#editTaskPriority").val();
        var projectId = $("#editTaskProjectId").val();
        var done = $("#editTaskIsDone").prop("checked");
        console.log(JSON.stringify({
            id:id,
            created: created,
            name:name,
            project_id: projectId,
            priority: priority
        }));

        $.ajax({
            type: "PUT",
            url: ajaxUrl+projectId+"/tasks/"+id,
            contentType: "application/json",
            data: JSON.stringify({
                id:id,
                created: created,
                name:name,
                priority: priority,
                done: done
            }),
            success: function() {
                $("#nameDiv_"+id).empty();
                $("#nameDiv_"+id).append(name);
                $("#checkBox_"+id+"_"+projectId).prop("checked", done);
            }
        });
    }

    function updateProject() {
        var name = $("#editProjectName").val();
        var projectId = $("#editProjectId").val();
        var created = $("#editProjectCreated").val();
        console.log(JSON.stringify({
            name:name,
            id:projectId
        }));

        $.ajax({
            type: "PUT",
            url: ajaxUrl+projectId,
            contentType: "application/json",
            data: JSON.stringify({
                id:projectId,
                created: created,
                name:name}),
            success: function() {
                $("#projectHeaderName_"+projectId).empty();
                $("#projectHeaderName_"+projectId).append(name);
            }
        });
    }

    function deleteTask(projectId, taskId) {
        $.ajax({
            type: "DELETE",
            dataType: "json",
            url: ajaxUrl+projectId+"/tasks/"+taskId,
            data: null,
        });
        $("#row_"+taskId).remove();
    }

    function deleteProject(projectId) {
        $.ajax({
            type: "DELETE",
            dataType: "json",
            url: ajaxUrl+projectId,
            data: null,
        });
        $("#projectRow_"+projectId).remove();
    }

    function taskRender(id, projectId, name, done, where) {
        var row = tableRow.replace(/taskId_/g,id).replace(/projectId_/g,"_"+projectId);
        where?
                $("#tbody_"+projectId).prepend(row):
                $("#tbody_"+projectId). append(row);
        $("#nameDiv_"+id).append(name);
        $("#checkBox_"+id+"_"+projectId).prop("checked", done);
        $("#checkBox_"+id+"_"+projectId).change(function(){
            setDone(this);
        });
    }

    function addTask(addTaskButtonId) {
        var projectId = addTaskButtonId.replace("addTaskButton_","");
        var name = $("#addTaskInput_"+projectId).val();
        $.ajax({
            type: "POST",
            url: ajaxUrl+projectId+"/tasks/",
            contentType: "application/json",
            data: JSON.stringify({
                name:name}),
            success: function(data) {
                taskRender(data.id,data.project.id,data.name, data.done,true);
                $("#addTaskInput_"+projectId).val('');
            }
        });
    }

    function updateTaskByData(data,projectId,where) {
        $.each(data, function(key, val) {
            taskRender(val.id,projectId,val.name, val.done, where);
        });
    }

    function getTasks(projectId) {
        $.ajax({
            dataType: "json",
            url: ajaxUrl+projectId+"/tasks/",
            data: null,
            success: function(data) {
                updateTaskByData(data,projectId,false)
            }
        });
    }

    function projectRender(id,name,where) {
        var element = projectRow.replace(/projectId_/g,id);
        where?
                $("#ajax_project_load").prepend(element):
                $("#ajax_project_load").append (element);
        $("#projectHeaderName_"+id).append(name);
    }

    function addProject() {
        var name = $("#addProjectName").val();
        $.ajax({
            type: "POST",
            url: ajaxUrl,
            contentType: "application/json",
            data: JSON.stringify({
                name:name}),
            success: function(data) {
                projectRender(data.id,data.name,false);
                $("#addProjectName").val('');
            }
        });
    }

    function updateProjectByData(data) {
        $.each( data, function(key, val) {
            var id = val.id;
            projectRender(id,val.name,true);
            getTasks(id);
        });

    }

    function getProjects() {
        $("#ajax_project_load").empty();
        $.ajax({
            dataType: "json",
            url: ajaxUrl,
            data: null,
            success: function(data) {updateProjectByData(data)}
        });
    }

    function setDone(checkBox) {
        projectId = checkBox.id.split('_')[2];
        id = checkBox.id.split('_')[1];
        done = $("#"+checkBox.id).prop("checked");
        $.ajax({
            type: "POST",
            url: ajaxUrl + projectId + "/tasks/" + id + "/status",
            data: {done: done}
        });
    }

    /* OnPageLoad */
    $(function () {
        getProjects();
    });

</script>
</body>

</html>
