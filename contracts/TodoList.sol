// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract TodoList {
    uint256 public taskCount;
    struct Task {
        string taskName;
        bool isCompleted;
    }
    mapping(uint256 => Task) public todos;
    event TaskCreated(string task, uint256 taskNumber);

    constructor() {
        taskCount = 0;
    }

    function createTask(string memory _taskName) public {
        // add task to mapping
        Task memory task = Task({taskName: _taskName, isCompleted: false});
        // increment task Count
        todos[taskCount++] = task;
        // emit event
        emit TaskCreated(_taskName, taskCount - 1);
    }
}
