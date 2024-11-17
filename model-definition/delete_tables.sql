-- HasHashtag
begin
   EXECUTE IMMEDIATE 'DROP TABLE HasHashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Hashtag
begin
   EXECUTE IMMEDIATE 'DROP TABLE Hashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Answer
begin
   EXECUTE IMMEDIATE 'DROP TABLE Answer';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Signal
begin
   EXECUTE IMMEDIATE 'DROP TABLE Signal';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Vote
begin
   EXECUTE IMMEDIATE 'DROP TABLE Vote';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Draft
begin
   EXECUTE IMMEDIATE 'DROP TABLE Draft';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Follow
begin
   EXECUTE IMMEDIATE 'DROP TABLE Follow';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Receive
begin
   EXECUTE IMMEDIATE 'DROP TABLE Receive';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- PrivateMessage
begin
   EXECUTE IMMEDIATE 'DROP TABLE PrivateMessage';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Options
begin
   EXECUTE IMMEDIATE 'DROP TABLE Options';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Survey
begin
   EXECUTE IMMEDIATE 'DROP TABLE Survey';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Post
begin
   EXECUTE IMMEDIATE 'DROP TABLE Post';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Users
begin
   EXECUTE IMMEDIATE 'DROP TABLE Users';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/