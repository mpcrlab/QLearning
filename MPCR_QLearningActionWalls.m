%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
%
% Machine Perception and Cognitive Robotics Laboratory
%
%     Center for Complex Systems and Brain Sciences
%
%              Florida Atlantic University
%
%------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
%% Q Learning Example
% This is a guide that will help explain how Q learning works. Various
% steps will be shown visually in order show how the process works.

%% Setting Up The Environment
% The map that the agent can move around in is an 8 by 8 grid. We first set
% it up by defining the number of rows and columns to both be 8.



function MPCR_QLearningAction

clear all
close all
clc

%% Setting Up The Environment
% The map that the agent can move around in is an 8 by 8 grid. We first set
% it up by defining the number of rows and columns to both be 8.

numrows = 10;
numcols = numrows;

%% 
% These are constants that will be later used in the Q learning equation. 
% G is gamma, and is used to ...
% L is the learning rate. This value...
% Epsilon is the chance that the agent will take a random action and not
% follow what it knows of the Q table. This allows it to make new
% discoveries instead of going with a path it has already discovered. By
% making random actions, there is a possibility the agent will take a
% better action and learn to do that instead of what it previously knew.
% However there is also a good chance that the random action will lead the
% agent further away from the reward state, but this is  part of the
% learning process. 1-epsilon is the chance the agent will take the best
% route it knows so far.

G = 0.95; %gamma
L = 0.75; %learning rate
epsilon = 0.33; %best option with chance (1-epsilon) else random

Sfinal = [numrows-1,numcols-1]; %Set the final location at (8,8). The agent will receive the reward in this location 

actions=4;

Q = zeros(numrows,numcols,actions);       % Fill the Q table with zeros. 
% The agent does not know anything about its environment and must update
% the table as it learns. Q is the utility, or reward, that the agent will
% receive depending on what action it takes. It will follow  the path that
% maximizes the Q values.
%------------------------------------------------------%
%------------------------------------------------------%
%% Main Loop
% This is the heart of the Q learning process. We'll run through it step by
% step.


for i =1:1000
    
    i
    s1 = [2,2];   % The initial state is (1,1)
    
    
    while (prod(s1 == Sfinal)==0)  % This while statement makes it so the
        % following code is executed if the agent is not in the final
        % state. It does this by checking if s1 and Sfinal are equal.
        % s1 is any state (x,y) the agent is in.
        % Sfinal is defined as (8,8). == checks the x and y of both states
        % and returns 0 if the numbers aren't equal and 1 if they are
        % equal. For example, state (8,2) returns (1,0) because s1's x
        % value is the same x value of Sfinal (8), but the y value's are
        % different. Taking the product of the result will always result in
        % either 0 or 1. If the agent is in the final state, s1==Sfinal is
        % true and yields (1,1), which is multiplied and gives 1. If
        % s1=/=Sfinal, there will be at least one 0 and when multiplied
        % results in 0. Hence, the following code is executed until the
        % agent is in the final state.
        
       
        [Qs1a,a]=max(Q(s1(1),s1(2),:)); % What is this?  The sum of all the 
        % utilities if the agent takes every possible action in a given
        % state? Qs1a,a. a runs through 1 to 4. Figure out what all Qs are
        % given the action. ?
        
        if s1(1) == 1 | s1(1) == numrows | s1(2) == 1 | s1(2) == numcols;
             epsilon = 1;
        else epsilon = .33;
        end 
        
        
        if i > 800;
            epsilon = .9;
        end 
            
        if (rand < (1-epsilon)) || (Qs1a==0)  % Rand is a random number 
            % between 0 and 1. If it is less than (1-epsilon) or if the 
            % Q value is unknown in that state...
            
            a=randi([1, actions]); % ... choose a random action. Randi
            % creates a random integer value between 1 and actions (which
            % is 4).
            
        end;
 
        
        
        [r,s2]=world(s1,a);  % What is world? 
        
        %
        %
        % *This is the actual Q learning equatiion* 
        
        Q(s1(1),s1(2),a) = ((1-L)*Q(s1(1),s1(2),a)) + L*((r+(G*(max(Q(s2(1),s2(2),:))))));
           
        % s1(1) is the original state. s1(2) is the next state, after
        % performing an action a. Q(s1(1), s1(2),a) is the utility of a
        % specific action. It is multipled by 1-L to weigh it (how so?).
        % max(Q(s2(1),s2(2),:) is the sum of all utilities from the
        % possible actions that can be made from state 2. The greater this sum, the
        % better it is for the agent to be in this position. The sum is
        % multiplied by G, which weighs the value. The larger the value of
        % G, the more the future reward is weighted. 
        % What is r and why is it added?
        % What does L do?
      
        s1 = s2;
        % The equation is repeated, except s2 is now the initial state and
        % the agent will choose actions and find the next state s3. The
        % process is repeated for a specified number of iterations.
        

%         if max(Q(1,1,:)) ~=0;    %what does the colon mean? What does ~=0
%         do?
          if mod(i,200) == 0  % shows every tenth iteration
            
            makeplots(s1,Q)
        
         end
    end;
    
    
end


end


%% Setting Up the Reward Table
% what is the difference between this and the previous section?

function [r,s2]=world(s1,a)

% The environment is still the same: an 8 by 8 grid.
numrows = 10;
numcols = numrows;

% The reward table is initially set to all zeros because the agent does not
% know anything about its environment, just like what was done with the Q
% table.
% The only information that the agent will eventually learn is that it will
% receive a reward of 100 at (8,8). It does not know that it will receive a
% reward or where the reward location is. The agent randomly explores its
% environment until it happens to arrive at that location and discover the
% reward. 
R = zeros(numrows,numcols);       % Reward matrix
         % Reward of 100 in Goal State
R(numrows-1,numcols-1) = 100;
R(:,numcols) = -100;
R(numrows,:) = -100;
R(:,1) = -100;
R(1,:) = -100;
%% Possible Actions
% The agent can make one of four actions in each episode: up, down, right,
% or left. The location is based on a coordinate grid, (x,y). Adding or
% subtracting 1 from the x-value moves the agent 1 unit left or right,
% respectively. Adding or subtracting 1 from the y-value moves the agent 1
% unit up or down, respectively.

switch a
    case 1
        s2=s1+[1,0];   % right
    case 2
        s2=s1+[-1,0];  % left
    case 3
        s2=s1+[0,-1];  % down
    case 4
        s2=s1+[0,1];   % up
    otherwise
        disp('Error')  % is this needed?
end


%% Walls to keep agent in box

s2(1)=max(s2(1),1);
s2(1)=min(s2(1),numrows);
s2(2)=max(s2(2),1);
s2(2)=min(s2(2),numcols);


r=R(s2(1),s2(2)); % This r is in the earlier equation. What is it used for?


end






%% Visualising the Information

function makeplots(s1,Q)

numrows = 10;
numcols = numrows;

A = zeros(numrows,numcols);         % Agent % What is this for?


Sfinal = [numrows-1,numrows-1]; %Reward in Last Array Location

A(:,numcols) = 3;
A(numrows,:) = 3;
A(:,1) = 3;
A(1,:) = 3;
A(Sfinal(1),Sfinal(2))=10; % color
A(2,2)= 5;  % ?


%------------------------------------------------------%
%------------------------------------------------------%
%Draw Agent Location Plot
% Run through the graphing. How?
A(s1(1),s1(2)) = 1;

subplot(131);
imagesc(A(end:-1:1,:))
title('Agent')
% axis off;
pause(0.05)


%Reset Agent Plot
A(s1(1),s1(2)) = 0;
A(Sfinal)=10;
A(1)=5;


%------------------------------------------------------%
%------------------------------------------------------%
%Draw Q Values Plot

% The Q value table is drawn for each of the 4 actions. There is a table
% that shows the Q values (or R?) for going forward, backward, left, and right
% for each state.



subplot(2,6,3);
imagesc(flip(Q(:,:,1)))
title('Q Values a=1=forward')
xlabel('State 2')
ylabel('State 1')


subplot(2,6,4);
imagesc(flip(Q(:,:,2)))
title('Q Values a=2=backward')
xlabel('State 2')
ylabel('State 1')

subplot(2,6,9);
imagesc(flip(Q(:,:,3)))
title('Q Values a=3=left')
xlabel('State 2')
ylabel('State 1')

subplot(2,6,10);
imagesc(flip(Q(:,:,4)))
title('Q Values a=4=right')
xlabel('State 2')
ylabel('State 1')


%------------------------------------------------------%
%------------------------------------------------------%
%Draw Best Route

s1 = [2,2]; % start at the initial position
route = zeros(numrows,numcols);
route(2,2)=1;
marker=1;

[Qs1a,a]=max(Q(s1(1),s1(2),:));

[r,s2]=world(s1,a);

while (Qs1a > 0)&&(prod(s2 == Sfinal)==0)  % Not sure how this all works
    
    
    [Qs1a,a]=max(Q(s1(1),s1(2),:));
    [r,s2]=world(s1,a);
    s1 = s2;
        
    route(s1(1),s1(2)) = marker;
    marker=marker+1;
    
    subplot(133);
    imagesc(route(end:-1:1,:))
    title('Best Route')

    
end

  drawnow()

end
