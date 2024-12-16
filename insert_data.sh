#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUN_RESULT=$($PSQL "TRUNCATE TABLE games, teams;")
echo $TRUN_RESULT


#add teams to database
cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $OPPONENT != "opponent" || $WINNER != "winner" ]]
then
echo $WINNER, $OPPONENT
CHECK_FOR_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
if [[ $CHECK_FOR_WINNER != $WINNER ]]
then
INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
echo $INSERT_TEAMS
fi
CHECK_FOR_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
if [[ $CHECK_FOR_OPPONENT != $OPPONENT ]]
then
INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
echo $INSERT_TEAMS
fi
#find all teams, that are unique
fi
done

#populate games table
cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# check frist record
if [[ "$YEAR" != "year" && -n "$YEAR" ]]
then
WINNER_SELECT=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_SELECT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_SELECT, $OPPONENT_SELECT, $WINNER_GOALS, $OPPONENT_GOALS)")
echo $INSERT_GAMES
fi
done

