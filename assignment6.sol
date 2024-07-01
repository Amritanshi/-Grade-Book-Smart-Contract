// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentGrades {
    address public instructor;

    struct StudentGrade {
        string name;
        string course;
        uint score;
    }

    StudentGrade[] public gradeRecords;

    modifier onlyInstructor() {
        require(msg.sender == instructor, "Function restricted to the instructor.");
        _;
    }

    constructor() {
        instructor = msg.sender;
    }

    function addGrade(string memory _name, string memory _course, uint _score) public onlyInstructor {
        gradeRecords.push(StudentGrade(_name, _course, _score));
    }

    function modifyGrade(uint _index, uint _score) public onlyInstructor {
        require(_index < gradeRecords.length, "Invalid index.");
        gradeRecords[_index].score = _score;
    }

    function fetchGrade(uint _index) public view returns (string memory, string memory, uint) {
        require(_index < gradeRecords.length, "Invalid index.");
        StudentGrade memory grade = gradeRecords[_index];
        return (grade.name, grade.course, grade.score);
    }

    function computeAverage(string memory _course) public view returns (uint) {
        uint totalScore = 0;
        uint numberOfGrades = 0;

        for (uint i = 0; i < gradeRecords.length; i++) {
            if (keccak256(bytes(gradeRecords[i].course)) == keccak256(bytes(_course))) {
                totalScore += gradeRecords[i].score;
                numberOfGrades++;
            }
        }

        if (numberOfGrades > 0) {
            return totalScore / numberOfGrades;
        } else {
            return 0;
        }
    }
}