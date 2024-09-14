CREATE TABLE Writer (
    writer_id NUMBER,
    name VARCHAR2(),
    contact_info VARCHAR2(),
    experience NUMBER,
    CONSTRAINT pk_writer PRIMARY KEY( writer_id )
);

CREATE TABLE Comic (
    comic_id NUMBER,
    comic_title VARCHAR2(255),
    genre VARCHAR2(50),
    no_of_characters NUMBER,
    summary CLOB,
    writer_id NUMBER,
    CONSTRAINT pk_comic PRIMARY KEY( comic_id ),
    CONSTRAINT fk_writer FOREIGN KEY (writer_id) REFERENCES Writer(writer_id)
);

CREATE TABLE Reviewer (
    reviewer_id NUMBER,
    place VARCHAR2(100),
    age NUMBER,
    gender VARCHAR2(10),
    CONSTRAINT pk_reviewer PRIMARY KEY( reviewer_id )
);

CREATE TABLE Feedback (
    feedback_id NUMBER,
    rating NUMBER,
    comment CLOB,
    comic_id NUMBER,
    reviewer_id NUMBER,
    CONSTRAINT pk_feedback PRIMARY KEY( feedback_id ),
    CONSTRAINT fk_comic FOREIGN KEY (comic_id) REFERENCES Comic(comic_id),
    CONSTRAINT fk_reviewer FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id)
);

CREATE TABLE CoAuthors (
    comic_id NUMBER,
    writer_id NUMBER,
    CONSTRAINT pk_coauthors PRIMARY KEY (comic_id, writer_id),
    CONSTRAINT fk_comic_coauthor FOREIGN KEY (comic_id) REFERENCES Comic(comic_id),
    CONSTRAINT fk_writer_coauthor FOREIGN KEY (writer_id) REFERENCES Writer(writer_id)
);